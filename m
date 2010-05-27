Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab0E0RR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:17:29 -0400
Received: from smtp.nokia.com ([192.100.122.230]:39003 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759278Ab0E0RRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:17:25 -0400
Date: Thu, 27 May 2010 20:15:53 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Alan Stern <stern@rowland.harvard.edu>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527171553.GC9625@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20100527162740.GA9625@nokia.com>
 <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 May 2010 17:16:03.0173 (UTC) FILETIME=[48E0F150:01CAFDC0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 07:04:24PM +0200, ext Alan Stern wrote:
>On Thu, 27 May 2010, Felipe Balbi wrote:
>
>> On Thu, May 27, 2010 at 05:06:23PM +0200, ext Alan Stern wrote:
>> >If people don't mind, here is a greatly simplified summary of the
>> >comments and objections I have seen so far on this thread:
>> >
>> >	The in-kernel suspend blocker implementation is okay, even
>> >	beneficial.
>>
>> I disagree here. I believe expressing that as QoS is much better. Let
>> the kernel decide which power state is better as long as I can say I
>> need 100us IRQ latency or 100ms wakeup latency.
>
>Does this mean you believe "echo mem >/sys/power/state" is bad and
>should be removed?  Or "echo disk >/sys/power/state"?  They pay no
>attention to latencies or other requirements.

no, not at all. I think they are also really useful. But I also think 
in-kernel suspend blockers are unnecessary. I think runtime pm + cpuidle 
+ cpufreq is well enough for all cases. We just need to give those three 
information about desired latencies.

-- 
balbi

DefectiveByDesign.org
