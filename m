Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2E3OcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:32:23 -0400
Received: from [204.209.205.32] ([204.209.205.32]:64823 "EHLO defout.telus.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab2E3OcV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:32:21 -0400
X-Authority-Analysis: v=1.1 cv=3felTBVTKDV4kUdUbqJShFvbTikv5tYY+WRXPduaGmg=
 c=1 sm=2 a=ur5R_stfBv0A:10 a=LGgl8L9ij00A:10 a=IkcTkHD0fZMA:10
 a=FGbulvE0AAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=danhDmx_AAAA:8
 a=D19gQVrFAAAA:8 a=20KFwNOVAAAA:8 a=Br9LfDWDAAAA:8 a=yrOjzl9yAAAA:8
 a=A6_IoWdwskp9QONEr-8A:9 a=QEXdDO2ut3YA:10 a=Mw4ukg_C7IkA:10 a=MSl-tDqOz04A:10
X-Telus-Outbound-IP: 209.121.28.192
From: "Doug Smythies" <dsmythies@telus.net>
To: "'Jonathan Nieder'" <jrnieder@gmail.com>,
        "=?utf-8?Q?'Anders_Bostr=C3=B6m'?=" <anders@netinsight.net>
Cc: <linux-kernel@vger.kernel.org>,
        "=?utf-8?Q?'Les=C5=82aw_Kope=C4=87'?=" <leslaw.kopec@nasza-klasa.pl>,
        "'Aman Gupta'" <aman@tmm1.net>,
        "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        "Doug Smythies" <dsmythies@telus.net>
References: <20120523.144057.899060240318474097.anders@netinsight.net> <20120523215359.GA19798@burratino> <20120524214516.GB1158@burratino>
In-Reply-To: <20120524214516.GB1158@burratino>
Subject: RE: [3.2.16 -> 3.2.17 regression] High reported CPU load when idle
Date: Wed, 30 May 2012 07:30:04 -0700
Message-ID: <000c01cd3e70$b651dd10$22f59730$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac059oUEh4VPnoLSSpKMOVSQCqsN1AEdsIyw
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The referenced PNG file was sent to everyone on the address list on 2012.05.22 and the previous version was sent 2012.05.09.
The only reason the PNG file was made was for the e-mail and because I was instructed not to refer to external sources.
The web page version of the PNG file, which is kept up to date, is at [3].

"does 556061b00c9f ("sched/nohz: Fix rq->cpu_load[] calculations", 2012-05-11) change anything?"
I back edited those changes into my test environment yesterday. It made no difference with respect to this issue. (minimally tested.)

This statement: "Starting with 3.2.17-1, the CPU load accounting is broken when the computer is idle. The CPU load is reported as >0.50 when idle. 3.2.16-1 don't suffer from this problem."
In my opinion has the following mistakes:
. The computer is not actually idle. If it was actually idle the reported load average would be 0.
. Yes, the new kernel reported load average is high, as detailed in the PNG file or the web notes.
. The older kernel suffers from a different problem, under all other conditions being the same, the reported load average would have been too low.

[3] http://www.smythies.com/~doug/network/load_average/new.html

Doug Smythies

-----Original Message-----
From: Jonathan Nieder [mailto:jrnieder@gmail.com] 
Sent: May-24-2012 14:45
To: Anders Boström
Cc: linux-kernel@vger.kernel.org; Lesław Kopeć; Aman Gupta; Doug Smythies; Peter Zijlstra; Thomas Gleixner
Subject: Re: [3.2.16 -> 3.2.17 regression] High reported CPU load when idle

(cc-ing Peter and Thomas because there is a nice graph)
> Anders Boström wrote[1]:

>> Starting with 3.2.17-1, the CPU load accounting is broken when the 
>> computer is idle. The CPU load is reported as >0.50 when idle. 
>> 3.2.16-1 don't suffer from this problem.
>>
>> Suspected patch is the upstream patch
>> "sched: Fix nohz load accounting -- again!"
>> commit 5e2d50da11f0e6ec3ce8fe658d7c83b0b4346c68 to 3.2 and 
>> originating from c308b56b5398779cd3da0f62ab26b0453494c3d4 .
>>
>> See also:
>>
>> https://bugs.launchpad.net/unity/+bug/991370
>> https://lkml.org/lkml/2012/5/22/310
>> https://bugzilla.redhat.com/show_bug.cgi?id=822877
>> https://bbs.archlinux.org/viewtopic.php?id=141289

I just found [1] from [2] which seems to describe the symptoms pretty well.  Peter, Thomas, advice?

Anders et al: does 556061b00c9f ("sched/nohz: Fix rq->cpu_load[] calculations", 2012-05-11) change anything?

Thanks,
Jonathan

[1] https://launchpadlibrarian.net/105809696/commit_low_load_rev2.png
[2] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/838811


