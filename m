Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1BCWJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 17:09:52 -0500
Received: from usindmx01.hds.com ([207.126.252.12]:38334 "EHLO
	usindmx01.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab1BCWJu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 17:09:50 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Date: Thu, 3 Feb 2011 17:08:01 -0500
Subject: RE: Query about kdump_msg hook into crash_kexec()
Thread-Topic: Query about kdump_msg hook into crash_kexec()
Thread-Index: AcvD5ziw50QwNj1iRDqHnMCcXQ6iMwABDFAg
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C147F43B7@USINDEVS01.corp.hds.com>
References: <20110131225939.GH11974@redhat.com>
	<20110203094715.939C.A69D9226@jp.fujitsu.com>
	<20110203020528.GA21603@redhat.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2C147F4346@USINDEVS01.corp.hds.com>
 <m14o8klt3w.fsf@fess.ebiederm.org>
In-Reply-To: <m14o8klt3w.fsf@fess.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Thank you for your prompt reply.

I would like to consider "Needs in enterprise area" and "Implementation of kmsg_dump()" separately.

(1) Needs in enterprise area
  In case of kdump failure, we would like to store kernel buffer to NVRAM/flush memory
  for detecting root cause of kernel crash.

(2) Implementation of kmsg_dump 
  You suggest to review/test cording of kmsg_dump() more.

What do you think about (1)?
Is it acceptable for you?

Seiji

>-----Original Message-----
>From: Eric W. Biederman [mailto:ebiederm@xmission.com]
>Sent: Thursday, February 03, 2011 4:13 PM
>To: Seiji Aguchi
>Cc: Vivek Goyal; KOSAKI Motohiro; linux kernel mailing list; Jarod Wilson
>Subject: Re: Query about kdump_msg hook into crash_kexec()
>
>Seiji Aguchi <seiji.aguchi@hds.com> writes:
>
>> Hi,
>>
>>>PS: FWIW, Hitach folks have usage idea for their enterprise purpose, but
>>>    unfortunately I don't know its detail. I hope anyone tell us it.
>>
>> I explain the usage of kmsg_dump(KMSG_DUMP_KEXEC) in enterprise area.
>>
>> [Background]
>> In our support service experience, we always need to detect root cause
>> of OS panic.
>> So, customers in enterprise area never forgive us if kdump fails and
>> we can't detect the root cause of panic due to lack of materials for
>> investigation.
>>
>>>- Why do you need a notification from inside crash_kexec(). IOW, what
>>>  is the usage of KMSG_DUMP_KEXEC.
>>
>>
>> The usage of kdump(KMSG_DUMP_KEXEC) in enterprise area is getting
>> useful information for investigating kernel crash in case kdump
>> kernel doesn't boot.
>>
>> Kdump kernel may not start booting because there is a sha256 checksum
>> verified over the kdump kernel before it starts booting.
>> This means kdump kernel may fail even if there is no bug in kdump and
>> we can't get any information for detecting root cause of kernel crash
>
>Sure it is theoretically possible that the sha256 checksum gets
>corrupted (I have never seen it happen or heard reports of it
>happening).  It is a feature that if someone has corrupted your code the
>code doesn't try and run anyway and corrupt anything else.
>
>That you are arguing against have such a feature in the code you use to
>write to persistent storage is scary.
>
>> As I mentioned in [Background], We must avoid lack of materials for
>> investigation.
>> So, kdump(KMSG_DUMP_KEXEC) is very important feature in enterprise
>> area.
>
>That sounds wonderful, but it doesn't jive with the
>code. kmsg_dump(KMSG_DUMP_KEXEC) when I read through it was simply not
>written to be robust when most of the kernel is suspect.  Making it in
>appropriate for use on the crash_kexec path.  I do not believe kmsg_dump
>has seen any testing in kernel failure scenarios.
>
>There is this huge assumption that kmsg_dump is more reliable than
>crash_kexec, from my review of the code kmsg_dump is simply not safe in
>the context of a broken kernel.  The kmsg_dump code last I looked code
>won't work if called with interrupts disabled.
>
>Furthermore kmsg_dump(KMSG_DUMP_KEXEC) is only useful for debugging
>crash_kexec.  Which has it backwards as it is kmsg_dump that needs the
>debugging.
>
>You just argued that it is better to corrupt the target of your
>kmsg_dump in the event of a kernel failure instead of to fail silently.
>
>I don't want that unreliable code that wants to corrupt my jffs
>partition anywhere near my machines.
>
>Eric
