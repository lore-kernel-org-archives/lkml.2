Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab1DSN5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:57:33 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:14809 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab1DSN5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:57:32 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zzbb2cK1444M179dN1432N98dKef8Kzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJWK1W-01-5QB-02
X-M-MSG: 
Date: Tue, 19 Apr 2011 15:55:18 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] perf, x86: Fix event scheduler for constraints with
 overlapping counters
Message-ID: <20110419135518.GZ31407@erda.amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
 <20110419102600.GU31407@erda.amd.com>
 <20110419112933.GA18660@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110419112933.GA18660@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.04.11 07:29:33, Ingo Molnar wrote:
> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > +				if (!state)
> > +					/* no events to reschedule */
> > +					goto done;
> 
> Hm, that's 5 levels of indentation. Would it be possible to factor out the gist 
> of the logic into a helper and such? My eyes would be much happier!

Hmm, I was thinking about this too, but it is not easy since we
control also the loops with goto's and updates of the loop
states. Refactoring out the inner block would mean to update state
varables via pointers and to introduce return codes which contains
control flow information. Don't think this will become easier.

We could probably merge both for-loops in one while-loop but also on
costs of code readability.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

