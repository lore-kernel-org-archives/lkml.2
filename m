Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2FLSsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:48:33 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54568 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab2FLSsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:48:32 -0400
Date: Tue, 12 Jun 2012 19:52:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org,
        jbottomley@parallels.com, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Can we pass a file handle down to the block ioctls to implement per
 file filters on scsi SG_IO ?
Message-ID: <20120612195200.2a1b6129@pyramind.ukuu.org.uk>
In-Reply-To: <4FD777A5.9050001@redhat.com>
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>
	<20120612175503.3462962f@pyramind.ukuu.org.uk>
	<4FD777A5.9050001@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Persistent reservations are exactly the kind of command that should have
> > a security model attached to them.
> 
> There is.  It's called "chmod"; you don't give write access to LUNs to
> random users.  and SCM_RIGHTS is what lets you override it securely.

Only you do - for virtual machines for example.

> > Red Hat seems to be an ever growing source of "mummy its hard, lets
> > disable all the security" type fixes. Please stop it.
> 
> Last time you were complaining that I was turning things *off* (SG_IO to
> partitions for root).  Now you complain that I'm turning things *on*.
> It's difficult to say they are the same thing.  Though perhaps you were
> talking about someone else.

Last time you were trying to break stuff that worked and stop the
privileged user doing it. This time you are tring to take away security
features that users might be relying on.

> > There is a sensible debate to be had about whether a lesser privilege
> > ought to be allowed. The real fix to this as with half of the other
> > crazy attempts to break all the security models that seem to keep spewing
> > forth is for someone who cares about it (that seems to me Red Hat) add
> > support for pushing a BPF filter onto a block device command queue. 
> 
> Sure; however, doing so requires access to some member of "struct file"
> from SG_IO.  Thus, ioctl would need to take a "struct file" rather than
> just an fmode_t.
> 
> The switch to fmode_t was done in 2007 by Al Viro.  I would like to
> understand the reasons for the switch; it seems to me that it was part
> of the big kernel lock removal.  If it's acceptable to undo it, I would
> very much would like to add generic BPF filtering to SG_IO

That would solve all sorts of problems in this area, so lets ping the man
himself -  Al ?

Alan
