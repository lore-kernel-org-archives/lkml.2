Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab2LDTUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 14:20:32 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:39673 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2LDTUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 14:20:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Bill Huey \(hui\)" <bill.huey@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAAmnkz=gJ02Uad6bgbCAuE0EPjcWXK9VrWo-3C1yK_XbmA4Xow@mail.gmail.com>
	<CAAmnkzkzCg8tR0k4VZRp_HPErE73ykFc7K8SpqEi7AU_6Dyk=g@mail.gmail.com>
Date: Tue, 04 Dec 2012 11:20:25 -0800
In-Reply-To: <CAAmnkzkzCg8tR0k4VZRp_HPErE73ykFc7K8SpqEi7AU_6Dyk=g@mail.gmail.com>
	(Bill Huey's message of "Tue, 4 Dec 2012 06:03:09 -0800")
Message-ID: <87txs162va.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19MV4B1k3x6vvIccg0RiZt/K9U3nSeEzcw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.6 FUZZY_AMBIEN BODY: Attempt to obfuscate words in spam
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0931]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Bill Huey \(hui\)" <bill.huey@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: BUG: wait_task_zombie NULL dereference
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Bill Huey (hui)" <bill.huey@gmail.com> writes:

> I should add that I encountered this on 3.6.0 with some mild
> modifications to the scheduler path that enqueue/dequeue a task before
> any of the schedule exit logic gets hit. The SCHED_FF/FIFO rebalancer
> does much the same so I can't imagine that being the source of the
> problem.
>
> I could be wrong however.

In 3.6 from_kuid_munged should be only be expanded to the inline noop
version.

The code you quote does not exist in kernel/exit.c in wait_task_zombie
and has not existed in wait_task_zombie in Linus's tree.  So since I
can't see the code I can't help.

I suspect the bug relates to your local modifications.

Eric
