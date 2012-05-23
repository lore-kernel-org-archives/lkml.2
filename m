Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763Ab2EWRjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:39:11 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18811 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760616Ab2EWRjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:39:09 -0400
Date: Wed, 23 May 2012 13:32:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH] fixes to stable/for-linus-3.5
Message-ID: <20120523173232.GA25974@phenom.dumpdata.com>
References: <1337636562-9579-1-git-send-email-konrad.wilk@oracle.com>
 <4FBD0A19.30701@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBD0A19.30701@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 05:02:33PM +0100, David Vrabel wrote:
> On 21/05/12 22:42, Konrad Rzeszutek Wilk wrote:
> > 
> > The autoballoon one would try to balloon up to E820_MAX when
> > there were no dom0_mem=.. argument.
> 
> I don't see this behaviour and looking at the code I don't see how it
> could.  The autoballoon code only populates pages that were released so
> it won't go above xen_start_info->nr_pages.

You are right. The ballooning up seems to be done by some other piece
of code.
> 
> Do you have any logs showing the problem behaviour?

I did. Let me re-run it and send it along.

> 
> > The patch fixes it, and
> > is also makes the dom0_mem=1G case work better (I think?). The
> > other solution would be to use the current_reservation patch
> > I posted a while back to work-around when no dom0_mem= argument
> > is used.
> 
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
