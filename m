Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab1GSMYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 08:24:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab1GSMYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 08:24:08 -0400
Message-ID: <4E25775A.4050306@redhat.com>
Date: Tue, 19 Jul 2011 08:23:54 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 01/34] System Firmware Interface
References: <1310994528-26276-1-git-send-email-prarit@redhat.com>	<1310994528-26276-2-git-send-email-prarit@redhat.com>	<m2vcuz3xsz.fsf@firstfloor.org> <20110719100544.55c7f7fb@lxorguk.ukuu.org.uk>
In-Reply-To: <20110719100544.55c7f7fb@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/19/2011 05:05 AM, Alan Cox wrote:
> On Mon, 18 Jul 2011 17:43:08 -0700
> Andi Kleen <andi@firstfloor.org> wrote:
>
>   

Hey Andi,

>> Prarit Bhargava <prarit@redhat.com> writes:
>>
>> Wow that's a cc list from hell. Cut down to linux-kernel.
>>     
> Which meant I very nearly missed it so you very nearly missed your answer
> 8)
>   

Sorry everyone -- I was just following what I thought was the proper
protocol ... I'll definitely cut down the cc list on the next submission.

>   
>>> This patch introduces a general System Firmware interface to the kernel, called
>>> sysfw.
>>>       
>> Could you expand somewhat WHY you want this. What is wrong with the
>> current code?
>>     
> See the previous discussions
>
>   

There is some additional information I'd like to throw out here as
well.  SMBIOS also provides information on the system state after the
BIOS/EFI is finished and before the kernel has been booted.  This has
been *invaluable* to me when diagnosing some wonky hardware from OEMs. 
I want to expand the SMBIOS layer to dump that information out when I
need it... but that's all for a later patch.  I will note not all
SMBIOSes are the same and sometimes the information has not been
correct, but when it is correct it has been extremely useful.  The
problem is that kludging this stuff into the existing dmi layer is a
PITA and just makes things messier with adding new dmi "devices" and
other junk.  It feels like I'm just hacking more code in to an already
broken mechanism.

tl;dr: There are some other useful bits of SMBIOS we could take
advantage of but the current "dmi" layer is difficult to work with.

Beyond that, what Alan said.

P.
>> As for user space access on x86 "dmidecode"/libdmi works for nearly everyone,
>> doesn't it?
>>     
> "on x86" (and on PC only generally)
>
> There are three core problems
>
> 1.	DMI in this sense is basically an x86 PC class device hack
> 2.	It is obsoleted and at some point it'll vanish even on PC
> 3.	Every other platform without DMI would benefit from the
> 	interface being generic
>
> So either we carry on hacking other interfaces (often more informative
> ones) into our dmi glue, and trying to keep up the fakery for every case,
> or we do what I should have done originally and made the interface a
> generic way to query firmware/board information that can be extended
> nicely.
>
> We'll still need a spot of fakery for userspace I suspect.
>   
