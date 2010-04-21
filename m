Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0DUKrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 06:47:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53400 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab0DUKrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 06:47:00 -0400
Subject: Re: pci_get_dev_by_id() from interrupt handlers
From: Peter Zijlstra <peterz@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Greg KH <greg@kroah.com>, Joerg Roedel <joro@8bytes.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100421104138.GH31537@amd.com>
References: <20100420160423.GD31537@amd.com>
	 <20100420163215.GB3270@kroah.com> <20100420173552.GA15669@8bytes.org>
	 <20100420175202.GA4874@kroah.com> <20100421100528.GG31537@amd.com>
	 <1271845271.1776.74.camel@laptop>  <20100421104138.GH31537@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 12:46:56 +0200
Message-ID: <1271846816.1776.84.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 12:41 +0200, Joerg Roedel wrote:
> On Wed, Apr 21, 2010 at 12:21:11PM +0200, Peter Zijlstra wrote:
> > On Wed, 2010-04-21 at 12:05 +0200, Joerg Roedel wrote:
> > > 
> > > > Why not do the whole thing in an interrupt task as the whole thing
> > > > sounds like something that shouldn't be done in interrupt context,
> > > > right?  Now that we have this type of functionality, we should take
> > > > advantage of it :)
> > > 
> > > Ok, I think I move the IOMMU interrupt handling to a tasklet.
> > > 
> > tasklet is softirq context, and is not what gregkh was talking about.
> > 
> > You'd still need to change the klist spinlock to be softirq-safe.
> 
> Ah right. Thanks for pointing this out. I couldn't find much about the
> interrupt tasks. Is it about the request_threaded_irq interface? And
> this would be run in the context of a kernel thread, right?

Right, request_threaded_irq() is what was meant, the comment there does
a good job of describing how to use it.



