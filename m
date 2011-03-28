Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab1C1KBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 06:01:46 -0400
Received: from m13-7.163.com ([220.181.13.7]:45759 "EHLO m13-7.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab1C1KBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 06:01:45 -0400
X-Greylist: delayed 984 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Mar 2011 06:01:45 EDT
Date: Mon, 28 Mar 2011 17:43:49 +0800 (CST)
From: xby <scxby@163.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        "xie.baoyou172958@zte.com.cn" <xie.baoyou172958@zte.com.cn>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Darren Hart" <dvhart@linux.intel.com>
Message-ID: <1d77e02c.13c15.12efbd90f7e.Coremail.scxby@163.com>
In-Reply-To: <1301300782.4859.7.camel@twins>
References: <1301300782.4859.7.camel@twins>
 <9e22ba.d2d5.12efb5a3d8f.Coremail.scxby@163.com>
Subject: Re:Re: PROBLEM:a bug about pi-futex maybe let the program going to
 hang
MIME-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [222.210.215.128]
X-Priority: 3
X-Mailer: Coremail Webmail Server Version SP_ntes V3.5 build
 110215(12912.3637.3636) Copyright (c) 2002-2011 www.mailtech.cn 163com
X-CM-TRANSID: B8GowKCbcsVWWJBNa38GAA--.7590W
X-CM-SenderInfo: xvf0u5i6rwjhhfrp/1tbiRQ8Qk0iSkaarmQACsU
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At 2011-03-28 16:26:22£¬"Peter Zijlstra" <peterz@infradead.org> wrote:

>On Mon, 2011-03-28 at 15:25 +0800, xby wrote:
>> hi, all.
>
>Works better if you also CC people who actually work on that code.
>
>>   Maybe, there is a bug about pi-futex, it would let the program in user-space going to hang.
>>  
>>   We have a board: CPU is powerpc 8572, two core. after ran one month, the state of pi-futex in user-space got bad: mutex->__data.__lock is 0x8000023e, mutex->__data.__count is 0, mutex->__data.__owner is 0.
>>  
>>   then, I review file "kernel/funtex.c"(the version is linux 2.6.38), found a case:
>>  
>>   if there are 3 thread, named threadA, threadB, threadC¡£thread A hold mutexM, threadB and threadC is waiting mutexM. They run as fllow steps:
>>  
>>   1. threadB and threadC sleep at line 1984.
>>   2. threadB receive a signal, then it will be wake up.
>>   3. threadA unlock mutexM, and give mutexM to threadB. 
>>   4. threadB call fixup_owner, try to give mutex to threadC.
>>   5. at line 1580, threadB trigger a addr-fault, then goto handle_fault.
>>   6. at line 1617, threadB release spinlock, then handle fault.
>>   7. threadC got spinlock, and call fixup_owner, and got mutexM.
>>   8. threadC give mutexM to threadB.
>>   9. threadB re-got spinlock, it will found "pi_state->owner == oldowner" and retry to fixup.
>>   10. threadB give mutexM to threadC, that's a bad thing.
>>  
>>   we have wrote a program, this program can prove all above.
>
>It would have been ever so much more useful if you'd have included that.

sorry, the code lies at office, and can't mail to all. I'm at home now ^-^

