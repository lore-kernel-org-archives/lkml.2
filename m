Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab0EYONN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 10:13:13 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:59092 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755432Ab0EYONL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 10:13:11 -0400
Message-ID: <4BFBDAF3.3020504@example.com>
Date: Tue, 25 May 2010 16:13:07 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Divyesh Shah <dpshah@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 icedove-bin/5449
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>	 <20100525094347.GA7881@elte.hu>  <4BFB9F0A.9040803@example.com> <1274781655.5882.765.camel@twins> <4BFBA0F8.9090908@example.com> <4BFBA6A2.4070405@example.com>
In-Reply-To: <4BFBA6A2.4070405@example.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 15795531268202656114
X-Ovh-Remote: 83.6.191.44 (abbb44.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.05.2010 12:29, Piotr Hosowicz wrote:
> On 25.05.2010 12:05, Piotr Hosowicz wrote:
>> On 25.05.2010 12:00, Peter Zijlstra wrote:
>>> On Tue, 2010-05-25 at 11:57 +0200, Piotr Hosowicz wrote:
>>>> On 25.05.2010 11:43, Ingo Molnar wrote:
>>>>
>>>>> This doesnt fix the whole issue. cpu_clock() is local, while the
>>>>> measurements
>>>>> done in the blk code are global ...
>>>>>
>>>>> While the warning is fixed this way, the far more serious issue is
>>>>> still
>>>>> there: time can go backwards if two points of time measurement are on
>>>>> different CPUs and can mess up the statistics with negative values,
>>>>> etc...
>>>>
>>>> How serious is this? Can it damage my data? I ask because the
>>>> machine is
>>>> my private computer, not any test machine.
>>>
>>> I'm not sure, since I didn't really look what they use the timestamps
>>> for, but a guess would say your data is safe, it might schedule the io
>>> funny, but it should not compromise integrity. At best its used purely
>>> for statistics and not even behaviour is affected.
>>
>> Thanks.
>
> Seems to work like a charm.

Not exactly. I looked into the syslog. I's much better, but I rebooted 
to single user mode to rebuild nvidia driver (new beta version) and I 
see same error (BUG ... code: ???) on shuting down, mentioning sync, 
umount and finally shutdown.

Anyway it's much more comfortable to build nvidia drivers in the console 
because previously the BUG lines cluttered all the console.

Regards,

Piotr Hosowicz



-- 
Z cyklu "Uroki demokracji", czyli pytania i odpowiedzi w teledurniejach:
- Co wydarzy³o siê w Dallas 22 listopada 1963 roku?
- Nie wiem, wtedy nie ogl±da³em.
NP: Slash - Paradise City (Feat. Fergie And Cypress Hill) (Australian Bonus)
NB: 2.6.34-20100524-1752-patched
