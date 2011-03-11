Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab1CKUpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:45:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52333 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab1CKUpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:45:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [RFC][PATCH 2/2] Convert several sysdev users to using struct syscore_ops
Date: Fri, 11 Mar 2011 21:45:45 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de
References: <201103100131.58206.rjw@sisk.pl> <201103112129.24876.rjw@sisk.pl> <20110311203305.GA21045@suse.de>
In-Reply-To: <20110311203305.GA21045@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103112145.45695.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 11, 2011, Greg KH wrote:
> On Fri, Mar 11, 2011 at 09:29:24PM +0100, Rafael J. Wysocki wrote:
> > I thought about two different possible ways forward:
> > 
> > (1) Push [1/2] and the patches converting things that x86 depends on first,
> >     followed perhaps by a patch introducing something like
> >     CONFIG_ARCH_NO_SYSDEV_OPS that would simply disable
> >     sysdev_{suspend|resume|shutdown}() (x86 would set it).  The other arches
> >     might then be converted over time.
> > 
> > (2) Prepare patches converting everything that can be converted in the tree
> >     and push them all in one shot.
> > 
> > The advantage of (1) is that we can start making changes RSN and the
> > advantage of (2) seems to be that we may avoid some potential suspend/resume
> > ordering issues on non-x86 architectures that may arise in principle if some
> > subsystems are converted to using struct syscore_ops while the others are
> > not (syscore_suspend() is executed after sysdev_suspend(), so if we move
> > something from the latter to the former, it may end up being executed after
> > things that it was executed before previously).
> > 
> > Please let me know what your opinion is.
> 
> Hm, I would prefer (1) as that lets us get this moving sooner, and "flag
> days" are never good to have.  If there are problems that arise because
> of it, as you have noted, it will be simple just to convert the parts
> that were using the "old" methods to the new ones to fix the issue,
> right?

Yes, I agree.

Thanks,
Rafael
