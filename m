Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab2CLVes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 17:34:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39785 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab2CLVeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 17:34:46 -0400
Date: Mon, 12 Mar 2012 16:34:37 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@lazy
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: Yves-Alexis Perez <corsac@debian.org>,
        ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [ibm-acpi-devel] [PATCH] thinkpad-acpi: recognize Lenovo as
 version string in newer V-series BIOS
In-Reply-To: <20120310160609.GA6254@khazad-dum.debian.net>
Message-ID: <alpine.DEB.2.02.1203121558340.3458@lazy>
References: <1331335944-4662-1-git-send-email-manoj.iyer@canonical.com> <1331335944-4662-2-git-send-email-manoj.iyer@canonical.com> <20120310042844.GA14972@khazad-dum.debian.net> <1331387907.2833.33.camel@scapa>
 <20120310160609.GA6254@khazad-dum.debian.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique/Yves-Alexis,

Yes, the V series systems are listed under Ideapad series on Lenovo's 
website. I initially was looking at why the Fn+F5 hotkey was not reporting 
a key event. Looking at the bios dsdt.dsl data on V480 I see

Device (HKEY)
                     {
                         Mutex (BFWM, 0x07)
                         Name (INDV, Zero)
                         Name (_HID, EisaId ("LEN0068"))
                         Method (_STA, 0, NotSerialized)

and it does not have the acpi_device_id of VPC2004 like other ideapads 
that I have seen, and seemed like the HKEY could be handled by 
thinkpad_acpi module. Product version string in DMI says "Lenovo V480" 
instead of "ThinkPad" and this was not recognized by the thinkpad_acpi 
module, thus my quirk to load the module.

After loading the module on the V480 I see:

[14511.946260] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[14511.946262] thinkpad_acpi: http://ibm-acpi.sf.net/
[14511.946264] thinkpad_acpi: ThinkPad BIOS H5ET23WW (0.23 ), EC unknown
[14511.946265] thinkpad_acpi: Lenovo Lenovo V480, model 14TD010
[14511.946707] thinkpad_acpi: detected a 8-level brightness capable 
ThinkPad
[14511.952009] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is 
unblocked
[14511.953099] Registered led device: tpacpi::thinklight
[14511.953156] Registered led device: tpacpi::power
[14511.953203] Registered led device: tpacpi::standby
[14511.953247] Registered led device: tpacpi::thinkvantage
[14511.953262] thinkpad_acpi: Standard ACPI backlight interface available, 
not loading native one
[14511.953420] thinkpad_acpi: Console audio control enabled, mode: monitor 
(read only)
[14511.955196] input: ThinkPad Extra Buttons as 
/devices/platform/thinkpad_acpi/input/input17

Fn+F15 now reports key press event, 00000080 00001005, and it reported 
nothing before when the module was not loaded. So prior to loading 
thinkpad_acpi, /lib/udev/findkeyboards == input/event3, /lib/udev/keymap 
-i input/event3 returned no valid values for Fn+F5 combo.

I am trying to get this patched module tested on other thinkpad and 
ideapads that we have to see if there are any regression or other issues. 
So, please let me know if this something worth supporting.


Thanks
Manoj

On Sat, 10 Mar 2012, Henrique de Moraes Holschuh wrote:

> On Sat, 10 Mar 2012, Yves-Alexis Perez wrote:
>> On sam., 2012-03-10 at 01:28 -0300, Henrique de Moraes Holschuh wrote:
>>> So far so good, but what driver functionality works well in these new
>>> lenovo boxes?
>>
>> V-series are Ideapad, so I'm not really sure this need to be added to
>> thinkpad-acpi.
>
> Yeah, it is not a thinkpad, not even in name.
>
> However, it just might have enough of the thinkpad ACPI API to work,
> thus my question.  What good does thinkpad-acpi do in a Lenovo Ideapad
> V-series?   If it does something useful, we can support it (but it
> likely needs more than just this patch to be safe).
>
> If it doesn't do anything useful, consider this as an absolute NACK
> (i.e. I will outright revert it if it lands).  Loading thinkpad-acpi on
> a notebook that doesn't benefit from it is harmful in the long term, as
> thinkpad-acpi can suddenly start calling weird stuff in ACPI on that box
> and do something bad.   There is a real reason why we restrict IBM-era
> stuff to IBM thinkpads, etc.
>
> --
>  "One disk to rule them all, One disk to find them. One disk to bring
>  them all and in the darkness grind them. In the Land of Redmond
>  where the shadows lie." -- The Silicon Valley Tarot
>  Henrique Holschuh
>
>

--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
