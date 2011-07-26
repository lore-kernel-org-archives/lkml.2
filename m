Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1GZRCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 13:02:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:2530 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab1GZRB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 13:01:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,270,1309762800"; 
   d="scan'208";a="31671144"
Message-ID: <4E2EF304.30601@linux.intel.com>
Date: Tue, 26 Jul 2011 10:01:56 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt3
References: <alpine.LFD.2.02.1107241223560.2702@ionos> <4E2C2ED6.4040904@gmail.com> <alpine.LFD.2.02.1107241807390.3136@ionos> <4E2DEC1A.5070109@linux.intel.com> <4E2E57FF.7030206@linux.intel.com> <4E2EA89A.2020007@gmail.com>
In-Reply-To: <4E2EA89A.2020007@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/26/2011 04:44 AM, Maarten Lankhorst wrote:
> On 07/26/2011 08:00 AM, Darren Hart wrote:
>> On 07/25/2011 03:20 PM, Darren Hart wrote:
>>> On 07/24/2011 09:12 AM, Thomas Gleixner wrote:
>>>> On Sun, 24 Jul 2011, Maarten Lankhorst wrote:
>>> ...
>>>
>>>>> Also not sure where this one came from:
>>>>> [   37.456688] BUG: spinlock bad magic on CPU#3, threaded-ml/1619
>>>>> [   37.456690]  lock: ffff8801fdc74d50, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
>>>>> [   37.456692] Pid: 1619, comm: threaded-ml Tainted: G         C  3.0.0-rt3-patser+ #39

Maarten, I'm finding fairly little out there on what threaded-ml might
be. What I do find suggests 3D visualization and real-time audio
playback. Are you working with something like this? If so, which
libraries are you using? If not, any idea what this is?

>>>>> [   37.456693] Call Trace:
>>>>> [   37.456697]  [<ffffffff81607a78>] spin_bug+0xa0/0xa8
>>>>> [   37.456699]  [<ffffffff8132b412>] do_raw_spin_lock+0xa2/0x170
>>>>> [   37.456702]  [<ffffffff8104a201>] ? get_parent_ip+0x11/0x50
>>>>> [   37.456704]  [<ffffffff8160d783>] _raw_spin_lock+0x23/0x30
>>>>> [   37.456706]  [<ffffffff810931ce>] rt_mutex_start_proxy_lock+0x2e/0xd0
>>>>> [   37.456708]  [<ffffffff8109093a>] futex_requeue+0x47a/0x850
>>>>> [   37.456710]  [<ffffffff8109138e>] do_futex+0xae/0xb00

Maarten, could you provide the addr2line of the addresses from do_futex
to spin_bug ? This will help me trace the path.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
