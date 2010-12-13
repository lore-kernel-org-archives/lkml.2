Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363Ab0LMRCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:02:38 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:59777 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758291Ab0LMRCg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:02:36 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTik78Lb0ejUiAvqbkToi=QAKSXXj_6JaBkPYw70Z@mail.gmail.com>
References: <cover.1290635422.git.bengardiner@nanometrics.ca>
	<cover.1291931041.git.bengardiner@nanometrics.ca>
	<87tyild2ms.fsf@deeprootsystems.com>
	<AANLkTik78Lb0ejUiAvqbkToi=QAKSXXj_6JaBkPYw70Z@mail.gmail.com>
Date: Mon, 13 Dec 2010 12:02:32 -0500
Message-ID: <AANLkTi=HiJGwtznGRzFDz-4ywsB3rYPW0yF5U_RUruzV@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] da850-evm: add gpio-{keys,leds} for UI and BB expanders
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        Gabor Juhos <juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Fri, Dec 10, 2010 at 11:33 AM, Ben Gardiner
<bengardiner@nanometrics.ca> wrote:
> On Fri, Dec 10, 2010 at 11:16 AM, Kevin Hilman
>> [...]
>> This series looks good to me, so I'll be queuing it in davinci-next for
>> 2.6.38.  It should show up in davinci git shortly. [...]
>
> Thank you very much, Kevin.
>
> I will check linux-davinci/master on monday.

I looked at git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git#davinci-next
; HEAD at the time was

  commit 3004ce0d3a44525de63e18b01f7734bc8d64f2c5
  Author: Ben Gardiner <bengardiner@nanometrics.ca>
  Date:   Thu Dec 9 16:51:07 2010 -0500

      da850-evm: KEYBOARD_GPIO_POLLED Kconfig conditional

      Use the mach-davinci/Kconfig to enable gpio-keys-polled as default when
      da850-evm machine is enabled.

      Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
      CC: Kevin Hilman <khilman@deeprootsystems.com>
      CC: "Nori, Sekhar" <nsekhar@ti.com>
      CC: Gabor Juhos <juhosg@openwrt.org>
      Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>

Everything seems to be in order there; I tested the resulting kernel
with evtest and the expected output was observed. Note that
davinci-next still contains the cherry-pick of the upstream commit of
the polled gpio keys driver:

  commit 03b79201321d53acc56b43cdd9d43e869f62021c
  Author: Gabor Juhos <juhosg@openwrt.org>
  Date:   Thu Dec 9 16:51:03 2010 -0500

      Input: add input driver for polled GPIO buttons

      The existing gpio-keys driver can be usable only for GPIO lines with
      interrupt support. Several devices have buttons connected to a GPIO
      line which is not capable to generate interrupts. This patch adds a
      new input driver using the generic GPIO layer and the input-polldev
      to support such buttons.

      [Ben Gardiner <bengardiner@nanometrics.ca: fold code to use more
       of the original gpio_keys infrastructure; cleanups and other
       improvements.]

      Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
      Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
      Tested-by: Ben Gardiner <bengardiner@nanometrics.ca>
      Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
      (cherry picked from commit 0e7d0c860a0dee49dacb7bbb248d1eba637075ad)
      Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>

I also looked at
git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git#master
; HEAD at the time was

  commit 4bfbdddc0655a284a98304bc343c6bcaf81b8e4d
  Merge: 771215c 7507fd3
  Author: Kevin Hilman <khilman@deeprootsystems.com>
  Date:   Fri Dec 10 16:25:27 2010 -0800

      rebuild linux-davinci from branches

There appears to be some double commits of the patch series. I tested
it with evtest anyways and also observed the expected output.

The following command and its output hopefully demonstrate what I am
seeing as double commits.

  $git log --format="%s -- %Cgreen%an <%aE> %Cred%ai %Creset%h" khilman/master
  rebuild linux-davinci from branches -- Kevin Hilman
<khilman@deeprootsystems.com> 2010-12-10 16:25:27 -0800 4bfbddd
  Merge branch 'davinci-orphaned' into davinci-reset -- Kevin Hilman
<khilman@deeprootsystems.com> 2010-12-10 16:25:22 -0800 771215c
  da850-evm: KEYBOARD_GPIO_POLLED Kconfig conditional -- Ben Gardiner
<bengardiner@nanometrics.ca> 2010-12-09 16:51:07 -0500 3004ce0
  da850-evm: add baseboard GPIO expander buttons, switches and LEDs --
Ben Gardiner <bengardiner@nanometrics.ca> 2010-12-09 16:51:06 -0500
61eaa3a
  da850-evm: extract defines for SEL{A,B,C} pins in UI expander -- Ben
Gardiner <bengardiner@nanometrics.ca> 2010-12-09 16:51:05 -0500
e594a12
  da850-evm: add UI Expander pushbuttons -- Ben Gardiner
<bengardiner@nanometrics.ca> 2010-12-09 16:51:04 -0500 260660f
  davinci: am18x/da850/omap-l138 evm: add support for higher speed
grades -- Sekhar Nori <nsekhar@ti.com> 2010-12-09 14:11:34 +0530
3c812e7
  davinci: am18x/da850/omap-l138: add support for higher speed grades
-- Sekhar Nori <nsekhar@ti.com> 2010-12-09 14:11:33 +0530 d2e9976
  rebuild linux-davinci from branches -- Kevin Hilman
<khilman@deeprootsystems.com> 2010-12-10 08:13:18 -0800 7507fd3
  Merge branch 'davinci-orphaned' into davinci-reset -- Kevin Hilman
<khilman@deeprootsystems.com> 2010-12-10 08:13:13 -0800 66a897a
  da850-evm: KEYBOARD_GPIO_POLLED Kconfig conditional -- Ben Gardiner
<bengardiner@nanometrics.ca> 2010-12-09 16:51:07 -0500 bc1c63f
  da850-evm: add baseboard GPIO expander buttons, switches and LEDs --
Ben Gardiner <bengardiner@nanometrics.ca> 2010-12-09 16:51:06 -0500
c6c519c
  da850-evm: extract defines for SEL{A,B,C} pins in UI expander -- Ben
Gardiner <bengardiner@nanometrics.ca> 2010-12-09 16:51:05 -0500
22693bc
  da850-evm: add UI Expander pushbuttons -- Ben Gardiner
<bengardiner@nanometrics.ca> 2010-12-09 16:51:04 -0500 b481719
  Input: add input driver for polled GPIO buttons -- Gabor Juhos
<juhosg@openwrt.org> 2010-12-09 16:51:03 -0500 03b7920
  ARM: Add writethrough dcache support for ARM926EJS processor -- Mark
A. Greer <mgreer@mvista.com> 2009-05-11 15:36:54 -0700 ecc2acc
  fb: davinci: DMx driver -- Kevin Hilman
<khilman@deeprootsystems.com> 2009-10-12 14:05:30 -0700 577b52a
  ASoC: davinci: SFFSDR board updates -- Kevin Hilman
<khilman@deeprootsystems.com> 2009-10-12 14:03:47 -0700 cdbc657
  davinci: dm365evm_keys driver -- David Brownell
<dbrownell@users.sourceforge.net> 2009-06-25 17:03:21 -0700 cf4e892
  davinci: kconfig: select at24 eeprom for selected boards -- Kevin
Hilman <khilman@deeprootsystems.com> 2010-11-19 07:25:30 -0800 22ca466
  da850-evm, trivial: use da850_evm prefix for consistency -- Ben
Gardiner <bengardiner@nanometrics.ca> 2010-11-19 16:43:04 -0500
3506f27
  da850-evm: allow pca953x module build -- Ben Gardiner
<bengardiner@nanometrics.ca> 2010-11-19 09:17:35 -0500 d5539ca
  davinci: da850-evm: UI expander gpio_set_value can sleep, use
_cansleep -- Ben Gardiner <bengardiner@nanometrics.ca> 2010-11-15
09:42:52 -0500 47e7cb1
  davinci: aemif: signedness bug in davinci_aemif_setup_timing() --
Nicolas Kaiser <nikai@nikai.net> 2010-11-15 19:40:28 +0100 12cdd3d
  davinci: psc: simplify if-statement -- Nicolas Kaiser
<nikai@nikai.net> 2010-10-25 14:41:18 +0200 1a07bfb
  davinci: minor tnetv107x clock tree fixes -- Cyril Chemparathy
<cyril@ti.com> 2010-10-20 17:49:57 -0400 ced9862
  davinci: use divide ratio limits from pll_data -- Cyril Chemparathy
<cyril@ti.com> 2010-10-20 17:49:56 -0400 b1d05be
  davinci: Implement sched_clock() -- Andreas Gaeer
<Andreas.Gaer@baslerweb.com> 2010-10-06 10:38:55 +0200 6d1c57c
  Linux 2.6.37-rc5 -- Linus Torvalds <torvalds@linux-foundation.org>
2010-12-06 20:09:04 -0800 cf7d7e5
  [...]

Note that the cherry pick of the upstream commit of the polled gpio
keys driver is here in 'master' also.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
