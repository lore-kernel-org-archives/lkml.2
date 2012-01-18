Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab2ARNkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:40:37 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:47752 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757489Ab2ARNkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 08:40:36 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/qDe0MZlLqUV2bS+yPdRyv8cLLwKpaIF2i6DQ3lg
	CMuM8pBOXjajP5
Subject: Re: [PATCH RT 2/4] wait-simple: Simple waitqueue implementation
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
In-Reply-To: <1326890703.17534.76.camel@gandalf.stny.rr.com>
References: <20120118034531.335521323@goodmis.org>
	 <20120118034700.245278561@goodmis.org>
	 <1326878928.7482.2.camel@marge.simson.net>
	 <1326890703.17534.76.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Jan 2012 14:40:17 +0100
Message-ID: <1326894017.12502.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 07:45 -0500, Steven Rostedt wrote:
> On Wed, 2012-01-18 at 10:28 +0100, Mike Galbraith wrote:
> > > +
> > > +void __init_swait_head(struct swait_head *head, struct lock_class_key *key)
> > > +{
> > > +	raw_spin_lock_init(&head->lock);
> > > +	lockdep_set_class(&head->lock, key);
> > > +	INIT_LIST_HEAD(&head->list);
> > > +}
> > > +EXPORT_SYMBOL_GPL(__init_swait_head);
> > 
> > #include <linux/module.h> ?
> 
> Did it fail to compile for you?  The 3.2 version included linux/export.h
> which didn't exist, and that failed the compile for me. I removed it an
> it compiled fine. But perhaps I should have replaced it with module.h.
> I'll look into it.

I saw compiler warning go zinging by, stopped the build and added the
include.  Trying to use the posted patches doesn't work without digging
out the signature damage, so it was easier to make my own.. and I too
just spanked the non-existent include :)

	-Mike 

