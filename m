Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab1AZAak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 19:30:40 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55171 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625Ab1AZAai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 19:30:38 -0500
X-Sasl-enc: jNhZrEcHvOwr+HJ/Al/WAXNsov+IN4NGM5u/Osacwwo5 1296001837
Date: Tue, 25 Jan 2011 22:30:34 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net, Dominik Kopp <my@kabelfunk.de>
Subject: Re: thinkpad-acpi: fn-f4 issues
Message-ID: <20110126003034.GC25953@khazad-dum.debian.net>
References: <Pine.LNX.4.64.1101251740380.3737@boston.corp.fedex.com>
 <20110125151346.GB14803@khazad-dum.debian.net>
 <AANLkTim9cN8KXx5DVrH_nBzVjnmuYsxOHwP4msBKs=gS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim9cN8KXx5DVrH_nBzVjnmuYsxOHwP4msBKs=gS@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011, Jeff Chua wrote:
> > Which thinkpad do you have that need CONFIG_THINKPAD_ACPI_HOTKEY_POLL to
> > handle Fn+F4?   I don't expect that to be needed on anything newer than a
> > T32...
> 
> X201s which is quite new.

Yay.  Send me dmidecode (XXX-out UUID and serial numbers) and output of of
acpidump, please.  And check that you have the latest version of the
firmware installed.

> thinkpad_acpi: ThinkPad ACPI Extras v0.24
> thinkpad_acpi: http://ibm-acpi.sf.net/
> thinkpad_acpi: ThinkPad BIOS 6QET62WW (1.32 ), EC 6QHT31WW-1.12
> thinkpad_acpi: Lenovo ThinkPad X201s, model 5413FGA
> thinkpad_acpi: detected a 8-level brightness capable ThinkPad
> thinkpad_acpi: radio switch found; radios are enabled
> thinkpad_acpi: possible tablet mode switch found; ThinkPad in laptop mode
> thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked

Well, it didn't complain about hotkeys, so it probably got all those that it
requested, which includes Fn+F4.  When in doubt, please either run the
driver in debug mode, or check the hotkey_mask in sysfs.

Please check with xev and something like input-events or some other
input-device snooper whether you get events when you press Fn+F4.  Maybe
userspace is ignoring it.

It should be something else, since poll mode seems to fix it, but let's get
the easy stuff out of the way first.

> thinkpad_acpi: volume: disabled as there is no ALSA support in this kernel
> input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input5
> 
> And the volume up/down does not work either even with thinkpad ALSA
> support enabled.

Check if something in userspace is listening to these keys.  They go over
the regular keyboard interface.  You don't have volume hotkeys or a mixer,
you just have two regular keys.  You'll be lucky if you still have a real
MUTE gate outside of the control of the HDA mixer...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
