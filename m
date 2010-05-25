Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab0EYKFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 06:05:50 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:57730 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756267Ab0EYKFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 06:05:48 -0400
Message-ID: <4BFBA0F8.9090908@example.com>
Date: Tue, 25 May 2010 12:05:44 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 icedove-bin/5449
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>	 <20100525094347.GA7881@elte.hu>  <4BFB9F0A.9040803@example.com> <1274781655.5882.765.camel@twins>
In-Reply-To: <1274781655.5882.765.camel@twins>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 11617316714479448463
X-Ovh-Remote: 83.6.191.44 (abbb44.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.05.2010 12:00, Peter Zijlstra wrote:
> On Tue, 2010-05-25 at 11:57 +0200, Piotr Hosowicz wrote:
>> On 25.05.2010 11:43, Ingo Molnar wrote:
>>
>>> This doesnt fix the whole issue. cpu_clock() is local, while the measurements
>>> done in the blk code are global ...
>>>
>>> While the warning is fixed this way, the far more serious issue is still
>>> there: time can go backwards if two points of time measurement are on
>>> different CPUs and can mess up the statistics with negative values, etc...
>>
>> How serious is this? Can it damage my data? I ask because the machine is
>> my private computer, not any test machine.
>
> I'm not sure, since I didn't really look what they use the timestamps
> for, but a guess would say your data is safe, it might schedule the io
> funny, but it should not compromise integrity. At best its used purely
> for statistics and not even behaviour is affected.

Thanks.

Cheers,

Piotr Hosowicz

-- 
"Wiedza to w³adza. Ale niewiedza, niestety, nie oznacza jeszcze
braku w³adzy." Niels Bohr
NP: Black Stone Cherry - Reverend Wrinkle
NB: 2.6.34-20100524-1752
