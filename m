Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab1ELOFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:05:06 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46503 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932110Ab1ELOE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:04:59 -0400
Subject: Re: [PATCH 0/3] Reduce impact to overall system of SLUB using
 high-order allocations
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
In-Reply-To: <4DCBC0E8.5020609@cs.helsinki.fi>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
	 <1305149960.2606.53.camel@mulgrave.site>
	 <alpine.DEB.2.00.1105111527490.24003@chino.kir.corp.google.com>
	 <1305153267.2606.57.camel@mulgrave.site>  <4DCBC0E8.5020609@cs.helsinki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 09:04:56 -0500
Message-ID: <1305209096.2575.14.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 14:13 +0300, Pekka Enberg wrote:
> On 5/12/11 1:34 AM, James Bottomley wrote:
> > On Wed, 2011-05-11 at 15:28 -0700, David Rientjes wrote:
> >> On Wed, 11 May 2011, James Bottomley wrote:
> >>
> >>> OK, I confirm that I can't seem to break this one.  No hangs visible,
> >>> even when loading up the system with firefox, evolution, the usual
> >>> massive untar, X and even a distribution upgrade.
> >>>
> >>> You can add my tested-by
> >>>
> >> Your system still hangs with patches 1 and 2 only?
> > Yes, but only once in all the testing.  With patches 1 and 2 the hang is
> > much harder to reproduce, but it still seems to be present if I hit it
> > hard enough.
> 
> Patches 1-2 look reasonable to me. I'm not completely convinced of patch 
> 3, though. Why are we seeing these problems now? This has been in 
> mainline for a long time already. Shouldn't we fix kswapd?

So I'm open to this.  The hang occurs when kswapd races around in
shrink_slab and never exits.  It looks like there's a massive number of
wakeups triggering this, but we haven't been able to diagnose it
further.  turning on PREEMPT gets rid of the hang, so I could try to
reproduce with PREEMPT and turn on tracing.  The problem so far has been
that the number of events is so huge that the trace buffer only captures
a few microseconds of output.

James


