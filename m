Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab1D1Jve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 05:51:34 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.182]:3971
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245Ab1D1Jvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 05:51:32 -0400
X-SpamScore: -29
X-BigFish: VPS-29(zzbb2cK4015L1444M179dN1432N98dKef8Kzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKCWO6-02-C9X-02
X-M-MSG: 
Date: Thu, 28 Apr 2011 11:50:29 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] perf, x86: Fix event scheduler for constraints with
 overlapping counters
Message-ID: <20110428095028.GN31407@erda.amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
 <20110419102600.GU31407@erda.amd.com>
 <20110419112933.GA18660@elte.hu>
 <20110419135518.GZ31407@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110419135518.GZ31407@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.04.11 15:55:18, Robert Richter wrote:
> On 19.04.11 07:29:33, Ingo Molnar wrote:
> > 
> > * Robert Richter <robert.richter@amd.com> wrote:
> > 
> > > +				if (!state)
> > > +					/* no events to reschedule */
> > > +					goto done;
> > 
> > Hm, that's 5 levels of indentation. Would it be possible to factor out the gist 
> > of the logic into a helper and such? My eyes would be much happier!
> 
> Hmm, I was thinking about this too, but it is not easy since we
> control also the loops with goto's and updates of the loop
> states. Refactoring out the inner block would mean to update state
> varables via pointers and to introduce return codes which contains
> control flow information. Don't think this will become easier.
> 
> We could probably merge both for-loops in one while-loop but also on
> costs of code readability.

Ingo, do you still want me to rework it?

Any other comments on this patch?

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

