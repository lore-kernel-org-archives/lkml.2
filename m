Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab1DYOuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 10:50:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758284Ab1DYOub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 10:50:31 -0400
Date: Mon, 25 Apr 2011 10:50:04 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        George Spelvin <linux@horizon.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/4] perf, nmi: Move LVT un-masking into irq handlers
Message-ID: <20110425145004.GG31724@redhat.com>
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
 <1303398203-2918-4-git-send-email-dzickus@redhat.com>
 <20110422082636.GC24011@elte.hu>
 <20110425133954.GA20887@redhat.com>
 <4DB581FD.8080006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB581FD.8080006@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 06:15:25PM +0400, Cyrill Gorcunov wrote:
> 
>   Don't get me wrong please but the whole picture of what is happening can be seen only when
> all caller sequence is taken into account and once (for some reason) the sequence
> get changed the "detailed" comment would simply mess the comment reader so I think
> the former comment is detailed enough and what is more important it's "general" enough
> so it doesn't depend on when code is called but points a reader on hw details and it's
> up to a reader to check "current" calling sequence because kernel code changes too
> damn fast ;)

I think Ingo is looking for is something like

/*
 * It has been observed that quirks in the P4 perf hw has forced the
 * following sequence of events to happen in the order below
 *
 * - clear the OVF bit (as it will continue to assert the NMI line)
 * - unmask the apic LVTPC bit to allow NMIs from the PMU again
 * - optionally re-enable the PMU to count events again
 *
 * Un-masking the apic prematurely (before clearing the OVF bit) has led
 * to the creation of a second NMI event (which led to the unknown NMI
 * warnings) due to the fact that the PMU will continue to generate an
 * interrupt until its OVF bit is cleared.
 */

Something that specifically documents what we saw, why we saw it and what
we are doing to avoid it.

Cheers,
Don
