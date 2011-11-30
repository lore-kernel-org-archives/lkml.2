Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab1LAAfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:35:10 -0500
Received: from ozlabs.org ([203.10.76.45]:37491 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab1LAAfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:35:08 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: Greg KH <greg@kroah.com>, Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, siglesia@cern.ch, manohar.vanga@cern.ch
Subject: Re: [RGC PATCH 0/2] split file2alias using elf sections
In-Reply-To: <20111122192300.GA5052@kroah.com>
References: <cover.1320408578.git.rubini@gnudd.com> <20111122192300.GA5052@kroah.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 30 Nov 2011 15:39:39 +1030
Message-ID: <87k46itcvg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011 11:23:00 -0800, Greg KH <greg@kroah.com> wrote:
> On Fri, Nov 04, 2011 at 01:23:00PM +0100, Alessandro Rubini wrote:
> > When adding a new bus type with autoloading of modules, people should
> > always change the global scripts/mod/file2alias.c source file, whereas
> > most of the new code is just new files and individual Makefile/Kconfig
> > lines.
> > 
> > The first patch turns all the "normal" alias generation in a
> > table-driven loop. The second patch moves a few alias types out of the
> > main file2alias.c source, as a demonstration that the thing works.
> > 
> > I didn't move all bus/alias types out of the main file, as it's a huge
> > work. But if the approach is going to be accepted I can do that (or
> > happily leave the task to who volunteers).
> 
> Yes!!!!
> 
> I've been wanting this for years, and so have others (Linus, Andrew,
> etc.)
> 
> I'll gladly take this through my driver-core tree, as it can handle
> cross-bus issues like this.
> 
> Do you feel this series is good enough to accept, or do you want to
> respin it again?

The table driven loop is nice and simple, though the E() macro is a bit
contrived.

The separation into separate files just to avoid merge issues is
overkill and useless churn.  The conflicts are simple, and you've just
moved themto conflicts in the Makefile.

We'd be better off putting the table in alphabetical order and stopping
there.  Easy code, no tricks.

Cheers,
Rusty.
