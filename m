Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773Ab0EZCvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 22:51:55 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:40059 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932105Ab0EZCvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 22:51:54 -0400
Message-ID: <4BFC8CC5.2000906@example.com>
Date: Wed, 26 May 2010 04:51:49 +0200
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
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>	 <20100525094347.GA7881@elte.hu>  <4BFB9F0A.9040803@example.com>	 <1274781655.5882.765.camel@twins> <4BFBA0F8.9090908@example.com>	 <4BFBA6A2.4070405@example.com> <4BFBDAF3.3020504@example.com>	 <4BFBE004.5060101@example.com> <1274798197.5882.1491.camel@twins>	 <4BFBE357.2040602@example.com> <1274804101.5882.1805.camel@twins> <4BFBFF34.1030907@example.com> <4BFC820B.3060206@example.com>
In-Reply-To: <4BFC820B.3060206@example.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10162091084378435954
X-Ovh-Remote: 83.6.191.44 (abbb44.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.05.2010 04:06, Piotr Hosowicz wrote:
> On 25.05.2010 18:47, Piotr Hosowicz wrote:
>> On 25.05.2010 18:15, Peter Zijlstra wrote:
>>> On Tue, 2010-05-25 at 16:48 +0200, Piotr Hosowicz wrote:
>>>> May 25 15:04:35 aapi205 kernel: [ 9694.523288] BUG: using
>>>> smp_processor_id() in preemptible [00000000] code: shutdown/16256
>>>> May 25 15:04:35 aapi205 kernel: [ 9694.523296] caller is
>>>> dqstats_inc+0x19/0x2c
>>>> May 25 15:04:35 aapi205 kernel: [ 9694.523299] Pid: 16256, comm:
>>>> shutdown Tainted: P W 2.6.34-20100524-1752-patched #1
>>>> May 25 15:04:35 aapi205 kernel: [ 9694.523301] Call Trace:
>>>> May 25 15:04:35 aapi205 kernel: [ 9694.523308] [<ffffffff811a537b>]
>>>> debug_smp_processor_id+0xc7/0xe0
>>>> May 25 15:04:35 aapi205 kernel: [ 9694.523311] [<ffffffff8112c0ad>]
>>>> dqstats_inc+0x19/0x2c
>>>> May 25 15:04:35 aapi205 kernel: [ 9694.523314] [<ffffffff8112ee66>]
>>>> vfs_quota_sync+0x1b1/0x293
>>>> May 25 15:04:35 aapi205 kernel: [ 9694.523319] [<ffffffff8103bf21>] ?
>>>> wake_up_process+0x10/0x12
>>>
>>> That's a different issue, see:
>>>
>>> http://lkml.org/lkml/2010/5/22/164
>>
>> I do not understand fully - does that mean I have to revert commit
>> a7cf4145b? And how to do it? Let's assume I git-pulled the source. What
>> should be next steps.
>
> Ok, my fault, now I know how to revert. But I still do not know if this
> is the right solution you meant. In the meantime I build the kernel
> after revert.

Ok, I reverted the commit, built the kernel and rebooted - the problem 
is still the same during shutdown.

Regards,

Piotr Hosowicz

-- 
- No wiesz, pijany i o trzeciej nad ranem wracasz do domu!?
- A kto powiedzia³, ¿e wracam? Po gitarê tylko przyszed³em.
NP: Slash - Ghost (Feat. Ian Astbury)
NB: 2.6.34-20100526-0324-pchd-and-revtd
