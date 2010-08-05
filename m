Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471Ab0HEAQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:16:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39218 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759361Ab0HEAQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:16:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: Attempted summary of suspend-blockers LKML thread
Date: Thu, 5 Aug 2010 02:15:13 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
References: <20100801054816.GI2470@linux.vnet.ibm.com> <201008050133.01169.rjw@sisk.pl> <alpine.DEB.2.00.1008041650470.6545@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.1008041650470.6545@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008050215.14319.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 05, 2010, david@lang.hm wrote:
> On Thu, 5 Aug 2010, Rafael J. Wysocki wrote:
> 
> > On Thursday, August 05, 2010, david@lang.hm wrote:
> >>
> >> My proposal would never freeze a subset of processes.
> >>
> >> what my proposal:
> >>
> >> only consider the activity of a subset of processes when deciding if we
> >> should suspend or not. If the decision is to suspend, freeze everything.
> >
> > That alone doesn't allow you to handle the race Matthew was referring to
> > (ie. wakeup event happening right after you've decided to suspend).
> >
> > A mechanism of making a decision alone is not sufficient, you also need a
> > mechanism to avoid races between wakeup events and suspend process.
> >
> 
> I thought you just posted that there was a new feature that would be able 
> to abort the suspend and so that race was closed.

Yes, you can use that for this purpose, but then you'd need a user space
power manager who would decide whether or not to suspend.  Then, however,
the problem boils down to setting up appropriate communication between the
power manager and the other applications in user space (ie. the kernel
doesn't need to be involved in that at all).

Thanks,
Rafael
