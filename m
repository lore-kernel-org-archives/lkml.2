Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab2GQWQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:16:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab2GQWQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:16:06 -0400
Message-ID: <1342563364.2229.166.camel@bling.home>
Subject: Re: [PATCH v5 1/4] kvm: Extend irqfd to support level interrupts
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Tue, 17 Jul 2012 16:16:04 -0600
In-Reply-To: <20120717220021.GE1868@redhat.com>
References: <20120716202711.1752.71007.stgit@bling.home>
	 <20120716203344.1752.14606.stgit@bling.home>
	 <20120717212612.GA2018@redhat.com> <1342562261.2229.155.camel@bling.home>
	 <20120717220021.GE1868@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 01:00 +0300, Michael S. Tsirkin wrote:
> On Tue, Jul 17, 2012 at 03:57:41PM -0600, Alex Williamson wrote:
> > On Wed, 2012-07-18 at 00:26 +0300, Michael S. Tsirkin wrote:
> > > On Mon, Jul 16, 2012 at 02:33:47PM -0600, Alex Williamson wrote:
> > > > @@ -96,6 +183,9 @@ irqfd_shutdown(struct work_struct *work)
> > > >  	 * It is now safe to release the object's resources
> > > >  	 */
> > > >  	eventfd_ctx_put(irqfd->eventfd);
> > > > +
> > > > +	_irq_source_put(irqfd->source);
> > > > +
> > > >  	kfree(irqfd);
> > > >  }
> > > >  
> > > 
> > > Hang on, this is a bug I think. This is done asynchronously.  So this
> > > means that I can assign MAX number of irqfds, then close one, and now
> >                          ^^^^^^^^^^^^^^^^^^^^ What is this?
> > Do you mean max irq source ids?
> 
> Yes, this is what I meant. Sorry about being unclear.
> 
> > > assign will fail because deassign did not get freed.
> > > 
> > > Maybe we can solve this by flushing wq before assign?
> > > Looks a bit fragile but may be enough - need to document well.

Why is this fragile?  We could even make it part of a retry so we don't
call it unless we need to.


