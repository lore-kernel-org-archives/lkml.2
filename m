Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab1CBDLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 22:11:38 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:15217 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757639Ab1CBDLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 22:11:36 -0500
Message-ID: <4D6DB566.4090908@bluewatersys.com>
Date: Wed, 02 Mar 2011 16:11:34 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: ext Nishanth Menon <nm@ti.com>, ext Tony Lindgren <tony@atomide.com>,
        Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
        ext Linus Walleij <linus.walleij@linaro.org>,
        Ambresh <a0393775@ti.com>, Andrei Warkentin <andreiw@motorola.com>,
        Lee Jones <Lee.Jones@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        David Brown <davidb@codeaurora.org>,
        Maxime Coquelin <maxime.coquelin-nonst@stericsson.com>,
        linux-arm-msm@vger.kernel.org, loic.pallardy@stericsson.com,
        "eduardo.valentin@nokia.com" <eduardo.valentin@nokia.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jouni Hogander <jouni.hogander@nokia.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv5 0/3] Introduce the /proc/socinfo and use it to export
 OMAP data
References: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com>	<AANLkTin7vRMreG3hOAk95MYZUCV-Kr6ac7gD7jgvX6Gf@mail.gmail.com>	<20110216115729.GA29817@besouro.research.nokia.com>	<4D6B78BF.1020102@stericsson.com>	<4D6C7B56.9060109@codeaurora.org>	<AANLkTikvhj49DftS9c_NouASY9_MbYPCfmSUdJg6pf-5@mail.gmail.com>	<4D6D9B10.9000606@codeaurora.org>	<4D6D9D06.2020204@bluewatersys.com>	<4D6D9FC7.1090206@codeaurora.org>	<4D6DA290.2010607@bluewatersys.com>	<4D6DAA24.3000204@codeaurora.org> <4D6DAE6E.4030701@bluewatersys.com> <4D6DB1B1.4060908@codeaurora.org>
In-Reply-To: <4D6DB1B1.4060908@codeaurora.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 03:55 PM, Saravana Kannan wrote:
> On 03/01/2011 06:41 PM, Ryan Mallon wrote:
>> On 03/02/2011 03:23 PM, Saravana Kannan wrote:
>>> I don't have any attachment to the "arch" file suggestion. If there is a
>>> better solution to identify the different implementations of socinfo
>>> without having to maintain some "unique id" list in the kernel, then I'm
>>> all for it. But cpuinfo is not it.
>>
>> Sorry I am confusing the 'arch' and 'mach' bits here. I definitely have
>> an objection to having an 'arch' file (i.e. ARM). A 'mach' (i.e. omap)
>> file makes a bit more sense, but should probably be called 'mach' rather
>> than 'arch' to avoid this confusion :-).
> 
> Sorry for the confusion. Sure, I don't care much for the filename as
> long as we can all agree on it. I care more about the content of the
> file (using names very close to xxxx in mach-xxxx). I like "soc-family"
> better since it's generic enough to not force, say omap3 and omap4, to
> report different values.
> 
> Linus Walleij, Eduardo, Maxime, Andrei,
> 
> Would like to hear your opinion on the file name (soc-family vs. mach vs
> <somethingelse>) and the path /sys/devices/system/soc/.

'family' sounds good. I don't think we need the 'soc-' prefix on
filenames if they are already in /sys/devices/system/soc/.

> 
> If we settle on this, may be it would be easier to get this through.
> 
>> I still think it is a solution in search of a problem though. What
>> userspace programs need to know what specific SoC they are on? My
>> feeling is that if userspace needs to know this information, then it is
>> probably dicking around with things that should be managed by the
>> kernel. Differences in available peripherals, etc can be determined by
>> looking at existing sysfs files.
> 
> I certainly have seen several use cases. Couple of easy examples:
> 
> * A lot of test scripts would find this very useful. For example, some
> clock (present is all/most MSMs) shouldn't be tested on some SOCs as it
> would lock up the system if you try to turn it off while the CPU is
> running.

I don't follow here. Do you mean a struct clk clock or something else?
Why is userspace allowed to disable a clock which will effectively hang
the system? :-).

> * Some of the user space tools might want to report different "product
> id/type" (nothing to do with USB, etc) depending on what SOC it is
> running on.

This makes more sense. It would actually be useful for custom USB
devices (gadget) which can be done from user space.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
