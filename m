Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab2EHUkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 16:40:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35214 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab2EHUkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 16:40:16 -0400
Date: Tue, 8 May 2012 21:43:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/3] pty: Lock the devpts bits privately
Message-ID: <20120508214309.2d50e5f0@pyramind.ukuu.org.uk>
In-Reply-To: <4FA9637B.1060609@zytor.com>
References: <20120503212151.568.91854.stgit@bob.linux.org.uk>
	<20120503212205.568.25804.stgit@bob.linux.org.uk>
	<4FA9637B.1060609@zytor.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 May 2012 11:18:35 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 05/03/2012 02:22 PM, Alan Cox wrote:
> > From: Alan Cox <alan@linux.intel.com>
> > 
> > This is a private pty affair, we don't want to tangle it with the tty_lock
> > any more as we know all the other non tty locking is now handled by the vfs
> > so we too can move.
> > 
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> > +		        mutex_lock(&devpts_mutex);
> >  			devpts_pty_kill(tty->link);
> > +		        mutex_unlock(&devpts_mutex);
> 
> > +	mutex_lock(&devpts_mutex);
> > +	tty = devpts_get_tty(pts_inode, idx);
> > +	mutex_unlock(&devpts_mutex);
> 
> > +	mutex_lock(&devpts_mutex);
> >  	tty = tty_init_dev(ptm_driver, index);
> > +	mutex_unlock(&devpts_mutex);
> 
> Conceptually this seems fine, but it would seem cleaner to me to push
> this mutex into the called functions in devpts; I suspect the lock could
> be eliminated or at least be made per instance there (which would make
> massive-container people happy...)

One step at a time. I agree entirely that the ideal case is that
devpts_foo is internally locked and coherent. That is an exercise for
someone who likes devpts 8)

Alan
