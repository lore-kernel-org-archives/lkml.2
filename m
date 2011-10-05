Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab1JEBsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 21:48:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58649 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757633Ab1JEBsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 21:48:36 -0400
Subject: Re: [Quilt-dev] [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: quilt-dev@nongnu.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        John Kacur <jkacur@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 05 Oct 2011 03:48:26 +0200
In-Reply-To: <1317753468.18063.19.camel@gandalf.stny.rr.com>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
	 <20111004180237.GA15087@suse.de>
	 <1317752148.18063.16.camel@gandalf.stny.rr.com>
	 <20111004182615.GA16224@suse.de>
	 <1317753468.18063.19.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317779312.1662.37.camel@schurl.linbit>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 14:37 -0400, Steven Rostedt wrote:
> On Tue, 2011-10-04 at 11:26 -0700, Greg KH wrote:
> 
> > > What are git's "split" subject: lines?
> > 
> > Do the following:
> >  $ git show --pretty=email 21d17dd2a377ba894f26989915eb3c6e427a3656
> > 
> > and look at how the Subject line is formatted:
> > 	Subject: [PATCH] ASoC: Fix setting update bits for WM8753_LADC and
> > 	 WM8753_RADC
> > 
> > Which is legal for email subject lines.  But quilt can't handle this and
> > ends up thinking the data after the Subject: line is part of the patch
> > text body and messes stuff up when doing 'quilt mail' later.

Aah, all this email parsing code is so ugly.  I think it works now
though.

> > Oh, then there's the issue of quilt not handling ',' in a Signed-off-by
> > line as a valid email address name, but I've been living with that one
> > for years...

That's not even valid in email addresses.  The proper way would be to
double-quote the "display name" which probably contains the comma, but
then quilt's edmail script still won't understand it.  Is this a real
problem?

Andreas

