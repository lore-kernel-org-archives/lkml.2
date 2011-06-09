Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab1FILP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:15:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34468 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab1FILPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:15:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF0AB5E.7080909@jp.fujitsu.com>
Date: Thu, 09 Jun 2011 20:15:42 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: ebiederm@xmission.com
CC: seiji.aguchi@hds.com, vgoyal@redhat.com, akpm@linux-foundation.org,
        xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
        jwilson@redhat.com
Subject: Re: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about kdump_msg
 hook into crash_kexec())
References: <20110203095837.93A2.A69D9226@jp.fujitsu.com>	<20110203020703.GB21603@redhat.com>	<20110203135324.93BC.A69D9226@jp.fujitsu.com>	<20110526131028.7052a893.akpm@linux-foundation.org>	<5C4C569E8A4B9B42A84A977CF070A35B2C17324B79@USINDEVS01.corp.hds.com>	<20110531213704.GV16382@redhat.com>	<5C4C569E8A4B9B42A84A977CF070A35B2C17324BB9@USINDEVS01.corp.hds.com> <m1ei3cq5gj.fsf@fess.ebiederm.org>
In-Reply-To: <m1ei3cq5gj.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Seiji Aguchi <seiji.aguchi@hds.com> writes:
> 
>> Hi,
>>
>>> What are you using kmsg_dump() for? Using mtdoops, ramoops or something
>>> else?  Is it working reliably for you?
>>
>> I plan to use kmsg_dump() for set_variable service of UEFI.
>> I proposed a prototype patch this month and will improve it.
>> (kmsg_dump is used inside pstore.)
>>
>> https://lkml.org/lkml/2011/5/10/340
> 
> Shudder.  Firmware calls in the crash path.
> 
> If that is the use, we need to remove the kmsg_dump(KMSG_DUMP_KEXEC)
> hook from crash_kexec yesterday.  It is leading to some really ludicrous
> suggestions that are on the way from making kexec on panic unreliable
> and useless.

Do you have concrete example?

If you only talked about theoretical issue, probably making boot parameter
is enough and reasonable way.


> There will always be EFI implementations where that will not work and
> there will be no way we can fix those.
> 
> There is a long history of people trying to do things in a crashing
> kernel, things that simply do not work when the system is in a bad
> state.  kmsg_dump() when I reviewed the code had significant
> implementation problems for being called from interrupt handlers
> and the like.
> 
> To introduce a different solution for capturing information when a
> kernel crashes we need to see numbers that in a large number of
> situations that the mechanism you are proposing is more reliable and/or
> more maintainable than the current kexec on panic implementation.
> 
> The best work I know of on the reliability of the current situation
> is "Evaluating Linux Kernel Crash Dumping Mechanisms", by Fernando Luis Vazquez Cao.
> http://www.linuxsymposium.org/archives/OLS/Reprints-2006/cao-reprint.pdf

Every reliability improvement idea is welcome! This also improve embedded too.


> Now it does happen to be a fact that our efi support in linux is
> so buggy kexec does not work let alone kexec on panic (if the target
> kernel has any efi support).   But our efi support being buggy is not
> a reason to add more ways to fail when we have a kernel with efi
> support.  It is an argument to remove our excessive use of EFI
> calls.

Which part is buggy? As far as I know, IBM, HP and Fujitsu have EFI supported
server product and it works.

So, if you are suffered from buggy efi, I think the best way is to make config
option and you disable it and Aguch-san enable it.


> So let's just remove the ridiculous kmsg_dump(KMSG_DUMP_KEXEC) hook from
> crash_kexec and remove any temptation for abuses like wanting to use
> kmsg_dump() on anything but a deeply embedded system where there simply
> is not enough memory for 2 kernels.

This sentence has two misunderstands. 1) modern embedded (e.g. Android) has
lots memory rather than 10 years past PC 2) they often don't need full feature
second kernel. they often don't need full crash dump.

Thanks.



