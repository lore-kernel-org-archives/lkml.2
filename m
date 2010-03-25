Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab0CYPw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:52:28 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:54967 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab0CYPw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:52:27 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zba6lz1432R98dN936eM62a3Lzz1202hzzz32i6bh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KZUHEX-02-M8J-02
X-M-MSG: 
Date: Thu, 25 Mar 2010 16:52:08 +0100
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/9] oprofile, perf, x86: introduce new functions to
 reserve perfctrs by index
Message-ID: <20100325155208.GI1585@erda.amd.com>
References: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
 <1267716131-17908-4-git-send-email-robert.richter@amd.com>
 <87eijfczqv.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87eijfczqv.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 25 Mar 2010 15:52:08.0960 (UTC) FILETIME=[203AC000:01CACC33]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

so far it does not seem this reservation patches will go upstream. So
we still do not have a solution of how to share the pmu with perf. The
current approach is a global pmu lock. I don't think this is a good
solution and we already see questions on the oprofile mailing list why
counters are not available to use. This will become much worse if perf
is using counters permanently in the kernel (e.g. the perf nmi
watchdog). This will make oprofile unusable.

On 20.03.10 06:45:44, Andi Kleen wrote:
> Robert Richter <robert.richter@amd.com> writes:
> 
> > Current perfctr reservation code allocates single pmu msrs. The msr
> > addresses may differ depending on the model and offset calculation is
> > necessary. This can be easier implemented by reserving a counter by
> > its index only.
> 
> Sorry reviewing old patch. This doesn't work for the fixed counters on intel,
> which don't have a index (or rather they have a separate number space)
> 
> I had a old patch to fix the reservation for them (and a matching
> patch to perf to use it).
> 
> How to resolve this?

Fixed counter reservation is not really used in the kernel except for
p4. Oprofile only reserves generic counters. Unless there is a general
solution how to reserve counters I don't see the need to extend the
reservation code for fixed counters since the only subsystem using it
would be the nmi watchdog.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

