Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab1DQIbG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 04:31:06 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:59437
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447Ab1DQIbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 04:31:00 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Apr 2011 04:31:00 EDT
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2cK98dKzz1202hzzz32i637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJSEY7-01-DQ3-02
X-M-MSG: 
Date: Sun, 17 Apr 2011 10:15:40 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf, x86: Fix event scheduler to solve complex
 scheduling problems
Message-ID: <20110417081540.GL31407@erda.amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
 <1302943877.32491.9.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1302943877.32491.9.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.04.11 04:51:17, Peter Zijlstra wrote:
> Argh, crap. That's because AMD is now the first with overlapping
> constraints. Be sure to let your hardware guys know that they went from
> top to bottom om my appreciation list. AMD used to have no constraints
> and now they have the absolute worst.

Yes, the overlapping constraints are the problem.

> I'd really prefer not to do this for .39, and I'll have to sit down and
> actually read this code. It looks like we went from O(n^2) to O(n!) or
> somesuch, also not much of an improvement. I'll have to analyze the
> solver to see what it does for 'simple' constraints set to see if it
> will indeed be more expensive than the O(n^2) solver we had.

It wont be more expensive, if there is a solution. But if there is no
one we walk all possible ways now which is something like O(n!).

Yes, we can shift this general solution after .39. Will try to find a
solution that handles the special case for family 15h as a fix for
.39.

> Also, I think this code could do with a tiny bit of comments ;-)

Will comment on the code inline in the patch.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

