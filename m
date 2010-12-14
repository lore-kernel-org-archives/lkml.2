Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab0LNQRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:17:17 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:38292 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180Ab0LNQRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:17:16 -0500
MIME-Version: 1.0
In-Reply-To: <8762ux49w7.fsf@deeprootsystems.com>
References: <cover.1290635422.git.bengardiner@nanometrics.ca>
	<cover.1291931041.git.bengardiner@nanometrics.ca>
	<87tyild2ms.fsf@deeprootsystems.com>
	<AANLkTik78Lb0ejUiAvqbkToi=QAKSXXj_6JaBkPYw70Z@mail.gmail.com>
	<AANLkTi=HiJGwtznGRzFDz-4ywsB3rYPW0yF5U_RUruzV@mail.gmail.com>
	<8762ux49w7.fsf@deeprootsystems.com>
Date: Tue, 14 Dec 2010 11:17:14 -0500
Message-ID: <AANLkTikUoKPG4o1+pt9r6V6H+6LrwZpTN8X9X+AkimiB@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 4:53 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> Ben Gardiner <bengardiner@nanometrics.ca> writes:
>> [...]
>> Everything seems to be in order there; I tested the resulting kernel
>> with evtest and the expected output was observed. Note that
>> davinci-next still contains the cherry-pick of the upstream commit of
>> the polled gpio keys driver:
>
> oops... I've now removed that, since it is part of v2.6.36-rc5 already.
> Thanks for checking.

Oops on my part...

I looked at git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git#davinci-next
again ; HEAD at the time was:

  commit 5682cfebad5e68736f4c54a268b5b371698f5262
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

and I was unable to build a kernel from da8xx_omapl_defconfig b/c:

  arch/arm/mach-davinci/board-da850-evm.c:333: error: unknown field
'poll_interval' specified in initializer

It appears that dropping the cherry-pick caused the build failure.

The commit that introduces the polled gpio keys driver (which was
included in the series as a cherry pick) is commit
0e7d0c860a0dee49dacb7bbb248d1eba637075ad which is in
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git#master
_after_ the tag v2.6.37-rc5.

That's my fault. I incorrectly thought that commit
0e7d0c860a0dee49dacb7bbb248d1eba637075ad was _in_ 2.6.37-rc5 and
stated this is previous emails. I'm sorry for the confusion; I think I
jumped the gun there due to my excitement at getting this prerequisite
driver committed.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
