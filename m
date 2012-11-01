Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067Ab2KARwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 13:52:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:21923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab2KARwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 13:52:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,695,1344236400"; 
   d="scan'208";a="235832341"
Date: Thu, 1 Nov 2012 10:52:17 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Julius Werner <jwerner@chromium.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH] xhci: fix null-pointer dereference when destroying
 half-built segment rings
Message-ID: <20121101175217.GJ29270@xanatos>
References: <1351530030-7080-1-git-send-email-jwerner@chromium.org>
 <508ECC63.3020302@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508ECC63.3020302@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 09:35:15PM +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 10/29/2012 08:00 PM, Julius Werner wrote:
> >  		next = xhci_segment_alloc(xhci, cycle_state, flags);
> >  		if (!next) {
> > -			xhci_free_segments_for_ring(xhci, *first);
> > +			prev = *first;
> > +			do {
> > +				next = prev->next;
> > +				xhci_segment_free(xhci, prev);
> > +			} while ((prev = next));
> 
>    It's preferred that the assignments are done outside the *if* and *while*
> statements. In fact, at least for the *if* statements scripts/checkpatch.pl
> gives a warning (it was silent in this case).

Hi Julius,

I agree with Sergei (for once).  The assignment in the while conditional
is confusing, and everyone reading the code will wonder if you meant
(prev == next).  Putting extra parenthesis around it to avoid static
type checker warnings is kind of missing the point.

Your patch does apply fine with git-am, so don't worry about the line
endings.  Can you please move the assignment into the loop and resubmit
this patch?

Sarah Sharp
