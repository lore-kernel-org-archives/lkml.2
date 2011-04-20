Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1DTTqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:46:07 -0400
Received: from n1.taur.dk ([217.198.219.102]:47138 "EHLO n1.taur.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab1DTTqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:46:06 -0400
Message-ID: <4DAF37B4.3040408@kasperkp.dk>
Date: Wed, 20 Apr 2011 21:44:52 +0200
From: Kasper Pedersen <kernel@kasperkp.dk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: x86: tsc: make TSC calibration more immune to interrupts
References: <4DAF2B57.6010100@kasperkp.dk> <1303326959.2796.136.camel@work-vm>
In-Reply-To: <1303326959.2796.136.camel@work-vm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2011 09:15 PM, john stultz wrote:
> On Wed, 2011-04-20 at 20:52 +0200, Kasper Pedersen wrote:
>> When a SMI or plain interrupt occurs during the delayed part
>> of TSC calibration, and the SMI/irq handler is good and fast
>> so that is does not exceed SMI_TRESHOLD, tsc_khz can be a bit
>> off (10-30ppm).

> I guess I'm curious how useful this is with the refined TSC calibration
> that was added not too long ago:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=08ec0c58fb8a05d3191d5cb6f5d6f81adb419798
> 
> Are you saying that you see the same 10-30ppm variance in the dmesg
> line: "Refined TSC clocksource calibration: XXXX.XXX MHz" ?
>

Yes, I do.
With the delayed workqueue patch, I see a wonderful 0.4ppm
offset _almost_ all of the time.

Very rarely though (about 1 in 3000) the value output by
"Refined TSC .." jumps. It can jump no further than
50000/F_TSC/delayed_time, so on a modern machine it jumps
no further than 20ppm.

This can happen when a short irq occurs between
*p = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
and
t2 = get_cycles();


Without the delayed workqueue patch 30ppm is insignificant.

/Kasper Pederen
