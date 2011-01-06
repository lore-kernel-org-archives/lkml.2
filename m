Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab1AFCSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 21:18:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753918Ab1AFCSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:18:35 -0500
Date: Wed, 5 Jan 2011 18:16:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] panic:  ratelimit panic messages
Message-Id: <20110105181641.23e02e1b.akpm@linux-foundation.org>
In-Reply-To: <20110106020512.GJ2317@redhat.com>
References: <1294198711-15492-1-git-send-email-dzickus@redhat.com>
	<1294198711-15492-2-git-send-email-dzickus@redhat.com>
	<20110105145128.3b635ae7.akpm@linux-foundation.org>
	<20110106020512.GJ2317@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jan 2011 21:05:12 -0500 Don Zickus <dzickus@redhat.com> wrote:

> > We keep on hacking away at this and things never seem to get much
> > better.  It's still the case that a large number of our oops reports
> > are damaged because the important parts of the oops trace scrolled off
> > the screen.
> > 
> > I therefore propose
> > 
> > 	oops_lines_delay=N,M
> > 
> > which will cause the kernel to pause for M milliseconds after emitting
> > N lines of oops output.  Bonus marks for handling linewrap!
> > 
> > Start the line counter at oops_begin() or thereabouts and then do the
> > delay after N lines have been emitted.  I guess that counter should
> > _not_ be invalidated in oops_end(): if the oops generates 12 lines and
> > then another 100 lines of random printk crap are printed, we still want
> > to put a pause after the 13th line of that random crap, so we can view
> > the oops.
> > 
> > The oops_lines_delay implemetnation should count lines from all CPUs
> > and should block all CPUs during the delay.
> > 
> > I think this would solve the problem which you're seeing, as well as
> > the much larger my-oops-scrolled-off problem?
> 
> Ok.  Forgive me for being thick.  I seem to be lost in the lower layer of
> the oops code for some reason.  I understand your idea and am willing to
> take a crack at implementing it,

ooh, goody.  I'd finally have an answer to all those useless cellphone
jpegs of scrolled-off oops traces.

> I just can't figure out what function to
> stick it in.  I grep'd for oops_begin() and it seemed to be an x86-only
> thing.  Is there a more generic place to put this stuff?

Sorry, braino.  oops_enter() and oops_exit().  All architectures
_should_ be calling oops_enter() right at the start of the oops
handling and oops_exit() right at the end.  They're suitable sites for
adding new stuff.


