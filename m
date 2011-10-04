Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab1JDS0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 14:26:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932752Ab1JDS0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:26:47 -0400
Date: Tue, 4 Oct 2011 11:26:15 -0700
From: Greg KH <gregkh@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: quilt-dev <quilt-dev@nongnu.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Kacur <jkacur@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
Message-ID: <20111004182615.GA16224@suse.de>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
 <20111004180237.GA15087@suse.de>
 <1317752148.18063.16.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317752148.18063.16.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 02:15:46PM -0400, Steven Rostedt wrote:
> On Tue, 2011-10-04 at 11:02 -0700, Greg KH wrote:
> > Now if only someone can get quilt working properly for git's "split"
> >  subject: lines, I would be very happy...
> 
> What issues do you have? I use quilt to send git patches all the time.

The other way around, I import git patches into quilt for the stable
series, and then when sending emails out, quilt messes up the subject
lines because it was split across two lines.

> What are git's "split" subject: lines?

Do the following:
 $ git show --pretty=email 21d17dd2a377ba894f26989915eb3c6e427a3656

and look at how the Subject line is formatted:
	Subject: [PATCH] ASoC: Fix setting update bits for WM8753_LADC and
	 WM8753_RADC

Which is legal for email subject lines.  But quilt can't handle this and
ends up thinking the data after the Subject: line is part of the patch
text body and messes stuff up when doing 'quilt mail' later.

So I have to remember to edit the subject: lines all the time, and
cringe when I forget.

Oh, then there's the issue of quilt not handling ',' in a Signed-off-by
line as a valid email address name, but I've been living with that one
for years...

thanks,

greg k-h
