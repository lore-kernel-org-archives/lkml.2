Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab1LEOuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 09:50:09 -0500
Received: from b.relay.invitel.net ([62.77.203.4]:48931 "EHLO
	b.relay.invitel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318Ab1LEOuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 09:50:07 -0500
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Dec 2011 09:50:06 EST
Date: Mon, 05 Dec 2011 15:39:46 +0100
From: Heiko Schocher <hs@denx.de>
Subject: Re: [PATCH] drivers, char: add U-Boot bootcount driver
In-reply-to: <20111204114741.GA5788@pengutronix.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Wolfgang Denk <wd@denx.de>, Vitaly Bordug <vbordug@ru.mvista.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Reply-to: hs@denx.de
Message-id: <4EDCD7B2.5030409@denx.de>
Organization: DENX Software Engineering
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
References: <1322991921-21096-1-git-send-email-hs@denx.de>
 <20111204114741.GA5788@pengutronix.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wolfram,

Wolfram Sang wrote:
> On Sun, Dec 04, 2011 at 10:45:21AM +0100, Heiko Schocher wrote:
>> This driver implements the Linux kernel half of the boot count feature -
>> the boot counter can only be reset after it is clear that the
>> application has been started and is running correctly, which usually
>> can only be determined by the application code itself. Thus the reset
>> of the boot counter must be done by application code, which thus needs
>> an appropriate driver.
> 
> An appropriate mechanism, not necessarily a driver, see below.
> 
>> Required feature by the Carrier Grade Linux Requirements Definition;
>> see for example document "Carrier Grade Linux Requirements Definition
>> Overview V3.0" at
>>
>> http://www.linuxfoundation.org/collaborate/workgroups/cgl/requirements#SMM.6.0_Boot_Cycle_Detection
>>
>>       Description: OSDL CGL specifies that carrier grade Linux
>>       shall provide support for detecting a repeating reboot cycle
>> 	due to recurring failures. This detection should happen in
>> 	user space before system services are started.
> 
> So, technically, a flag would be enough, not necessarily a counter? Although a
> counter probably has more advantages...
> 
>> This driver provides read/write access to the U-Boot bootcounter
>> through PROC FS and/or sysFS file.
> 
> Why ProcFS? Why ProcFS and/or SysFS? Which has priority? Why not /dev?

I drop the ProcFS support for v2.

>> The bootcountregister gets configured via DTS.
>> for example on the enbw_cmc board:
>>
>> bootcount@0x23060 {
>>                   compatible = "uboot,bootcount";
> 
> No. I assume you are not the vendor of what is at 0x23060, the actual device.
> Only the device must be encoded in the compatible-entry which then implies the
> bootcount functionality. Also, keep in mind that your solution should be
> generic for bootloaders.

So I should call it compatible = "generic, bootcount" ?

>>                   reg = <0x23060 0x20>;
> 
> I assume that non-volatile memory would qualify as a boot-counter, so those
> could be tied to I2C busses etc? reg would not fit then.

Currently, mem only supported, add this to the Documentation and log
message.

> I do wonder if it makes more sense to add such functionality to the
> watchdog-core to save the additional device (CCed). Needs a second thought,
> though...

Thanks!

bye,
heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
