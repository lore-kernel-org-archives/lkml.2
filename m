Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0CVXZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 19:25:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40203 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab0CVXZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 19:25:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=izd7R1nZK4Fxpsyn/lcYG24VQyxX+v5h+xcUl7dah4+vcZ+jRhovt/HQvSj6in9HHv
         +eRW+8PxmTIUy7HE/KdPZJZSt9tDSRIgLOYHJsNKd0Cz08avVQLNpNF5uKf4lDfS7NBY
         Y18CkZpwVpmwan2pDnoPdKiUdMXl5e6IyV224=
Message-ID: <4BA7FC63.6000503@gmail.com>
Date: Mon, 22 Mar 2010 16:25:23 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Zbigniew Luszpinski <zbiggy@go2.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32 help needed with reverting APIC patches.
References: <201003220123.37341.zbiggy@go2.pl> <4BA716E5.2060800@gmail.com> <201003230018.15750.zbiggy@go2.pl>
In-Reply-To: <201003230018.15750.zbiggy@go2.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 04:18 PM, Zbigniew Luszpinski wrote:
>> best would be todo a bisect. but if your for sure these
>> are the commits, then you probably wont need too.
>>
>> if your doing git revert xxxx
>> and the commit reverts for you then your good,
>> but if there's too much happening(big merge), then
>> a git rebase probably is the best bet(but could be wrong).
>>
>> hope this helps.
>>
>> Justin P. Mattock
>>
>
> Yeah I imagine reverting patches from kernel 2.6.32.10 up to 2.6.20 and seeing all these conflicts in git.
> I have just done this in different way: downloaded official 2.6.32.10 and manually reinserted the removed code.
> I resolved IRQ_DELAYED_DISABLE irq.h conflict by moving it to higher bitfield position.
> The patched kernel booted OK but these reverts did not resolve the OHCI hangs in APIC mode.
> The final verdict is: idea #1 was false.
> Now I focus on #2 and #3 ideas.
>
> Call for action:
> 1. If you have any idea why ohci hangs in APIC mode let me know.
> 2. If you have Nvidia MCP78S mainboard with AMD CPU please send me ACPI dump:
> acpidump>  dump.bin
> bzip2 -9v dump.bin
> This will be good APIC code comparison to check the #3 idea.
> Do not mess the ML with attachments - send me the file(s) PM.
>
> On my mainboard almost all onboard devices are sitting on INT A according to ACPI code.
> Only USB 2.0 EHCI controller sits on INT B alone.
>
> have a nice day,
> Zbigniew Luszpinski
>


for number one, the only thing off the top of my
head would possibly be load time i.g. if ehci_hcd loads
after ohci is loaded there could be a conflict or vice/versa
with something else.

for number two, I don't have an AMD processor here only and intel
(iMac)

Justin P. Mattock
