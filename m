Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab1BRI3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 03:29:50 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41440 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab1BRI3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 03:29:47 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, opurdila@ixiacom.com
References: <m1sjvm822m.fsf@fess.ebiederm.org>
	<AANLkTimzP0UNRXutkt1zJ+OGhmeg6ga87HFyMuZQmpMj@mail.gmail.com>
	<AANLkTi=kEEip7UjtLqvo0Hpz8uwjVdx334hYnPsoNXis@mail.gmail.com>
	<20110217.204036.226788819.davem@davemloft.net>
	<AANLkTin2XX-HHFqnAajUYPU23WeuOZk7vvGczmijUEy=@mail.gmail.com>
Date: Fri, 18 Feb 2011 00:29:37 -0800
In-Reply-To: <AANLkTin2XX-HHFqnAajUYPU23WeuOZk7vvGczmijUEy=@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 17 Feb 2011 20:57:39 -0800")
Message-ID: <m1r5b568zy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18KZhzv3u4eaUAn8rzUMvOhdT1x0XMmvJc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in 2.6.38-rc4
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Feb 17, 2011 at 8:40 PM, David Miller <davem@davemloft.net> wrote:
>>
>> I looked at Eric's (and your) patch before I wrote my reply :-)
>
> It was Eric Biederman that was missing from some of the discussion.
> Too many Eric's, and two separate threads for the same bug that I'm
> involved in.

I have a kernel with both your patches running and testing now.

Before I got the new kernel built I saw a second of these in the same
place, followed by a boat load of soft lockups.

> BUG: unable to handle kernel paging request at ffff88018f30b760
> IP: [<ffffffff8140c7ca>] unregister_netdevice_queue+0x3a/0xb0
> Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
> last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
> Stack:
> Call Trace:
> Code: 24 08 48 89 fb 49 89 f4 e8 f4 c8 00 00 85 c0 74 6d 4d 85 e4 74 3b 48 8b 93 a0 00 00 00 48 8b 83 a8 00 00 00 48 8d bb a0 00 00 00 <48> 89 42 08 48 89 10 4c 89 e2 49 8b 74 24 08 e8 32 75 e7 ff 48 
> RIP  [<ffffffff8140c7ca>] unregister_netdevice_queue+0x3a/0xb0
> CR2: ffff88018f30b760
> BUG: soft lockup - CPU#0 stuck for 67s! [as:4762]
> Stack:
> Call Trace:
> Code: c9 c3 0f 1f 80 00 00 00 00 48 8b 05 21 f9 a4 00 81 c6 f0 00 00 00 ff 90 e0 00 00 00 48 83 7b 08 00 74 a7 66 0f 1f 44 00 00 f3 90 <49> 83 bc 24 48 c4 c1 81 00 75 f3 eb 92 66 0f 1f 84 00 00 00 00 
> BUG: soft lockup - CPU#4 stuck for 67s! [cc1plus:23768]
> Stack:
> Call Trace:
> Code: c9 c3 0f 1f 80 00 00 00 00 48 8b 05 21 f9 a4 00 81 c6 f0 00 00 00 ff 90 e0 00 00 00 48 83 7b 08 00 74 a7 66 0f 1f 44 00 00 f3 90 <49> 83 bc 24 48 c4 c1 81 00 75 f3 eb 92 66 0f 1f 84 00 00 00 00 
> BUG: spinlock lockup on CPU#6, kworker/u:0/23281, ffff880154f7d650
> BUG: spinlock lockup on CPU#3, configure/4328, ffffffff81a13740
> Stack:
> Call Trace:
> Code: c3 90 90 90 90 55 89 f8 48 89 e5 e6 70 e4 71 c9 c3 0f 1f 40 00 55 89 f0 48 89 e5 e6 70 89 f8 e6 71 c9 c3 66 90 55 48 89 e5 0f 31 <89> c1 48 89 d0 48 c1 e0 20 89 c9 48 09 c8 c9 c3 66 2e 0f 1f 84 
> Stack:
> Call Trace:
> Code: e8 b6 0f 27 00 c9 c3 90 90 90 90 55 89 f8 48 89 e5 e6 70 e4 71 c9 c3 0f 1f 40 00 55 89 f0 48 89 e5 e6 70 89 f8 e6 71 c9 c3 66 90 <55> 48 89 e5 0f 31 89 c1 48 89 d0 48 c1 e0 20 89 c9 48 09 c8 c9 
> Stack:
> Call Trace:
> Code: c3 90 90 90 90 55 89 f8 48 89 e5 e6 70 e4 71 c9 c3 0f 1f 40 00 55 89 f0 48 89 e5 e6 70 89 f8 e6 71 c9 c3 66 90 55 48 89 e5 0f 31 <89> c1 48 89 d0 48 c1 e0 20 89 c9 48 09 c8 c9 c3 66 2e 0f 1f 84 
> Stack:
> Call Trace:
> Code: c8 c9 c3 66 0f 1f 44 00 00 55 48 89 e5 ff 15 b6 e2 7b 00 c9 c3 0f 1f 40 00 55 48 8d 04 bd 00 00 00 00 65 48 8b 14 25 98 1e 01 00 <48> 8d 0c 12 48 c1 e2 06 48 89 e5 48 29 ca f7 e2 48 8d 7a 01 ff 
> Stack:
> Call Trace:
> Code: 0f 1f 80 00 00 00 00 f3 90 65 8b 1c 25 f0 c4 00 00 41 39 dd 75 23 66 66 90 0f ae e8 e8 96 ef d8 ff 66 90 48 98 48 89 c2 4c 29 e2 <4c> 39 f2 72 d7 5b 41 5c 41 5d 41 5e c9 c3 49 29 c4 4d 01 e6 66 
> Stack:
> Call Trace:
> Code: c3 90 90 90 90 55 89 f8 48 89 e5 e6 70 e4 71 c9 c3 0f 1f 40 00 55 89 f0 48 89 e5 e6 70 89 f8 e6 71 c9 c3 66 90 55 48 89 e5 0f 31 <89> c1 48 :


And then a little later when I was rebooting after installing the kernel
with the bug fixes I got another bug.  I suspect this is probably
unrelated, as I have had some indication that mavlan has had problems
for a while.

> =============================================================================
> BUG kmalloc-4096: Poison overwritten
> -----------------------------------------------------------------------------
> 
> INFO: 0xffff880297f8b488-0xffff880297f8b48f. First byte 0x0 instead of 0x6b
> INFO: Allocated in macvlan_common_newlink+0x114/0x390 [macvlan] age=1890967 cpu=1 pid=3099
> INFO: Freed in macvlan_port_rcu_free+0x10/0x20 [macvlan] age=133 cpu=6 pid=0
> Sending all procINFO: Slab 0xffffea000913e5c0 objects=7 used=0 fp=0xffff880297f89048 flags=0x40000000004080
> INFO: Object 0xffff880297f8b0d8 @offset=12504 fp=0xffff880297f8a090
> esses the KILL s
> Bytes b4 0xffff880297f8b0c8: ignal...  31 27 1d 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a 1'......ZZZZZZZZ
>   Object 0xffff880297f8b0d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b0e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b0f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b108:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b118:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b128:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b138:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b148:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b158:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b168:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b178:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b188:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b198:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b1a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b1b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b1c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b1d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b1e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b1f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b208:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b218:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b228:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b238:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b248:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b258:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b268:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880297f8b278:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
....

Eric
