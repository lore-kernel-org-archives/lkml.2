Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2KTShb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:37:31 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:41727 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751582Ab2KTSha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:37:30 -0500
Message-ID: <1353436648.17387.3.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: consolidate if (foo) bar(foo) checks and
 add debugfs_remove
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Constantine Shulyupin <const@makelinux.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Date: Tue, 20 Nov 2012 10:37:28 -0800
In-Reply-To: <20121120163956.GD17797@dm>
References: <1353190818-10070-1-git-send-email-const@MakeLinux.com>
	 <20121120142906.GD7955@dm> <1353422629.11235.10.camel@joe-AO722>
	 <20121120144742.GG7955@dm>
	 <CAE7jHC8LsxPaQHqy5-H4-wZp6q+_0s7arnPa3jG7R9x=tf_Oww@mail.gmail.com>
	 <1353423503.11235.12.camel@joe-AO722> <20121120153751.GJ7955@dm>
	 <1353426677.11235.15.camel@joe-AO722> <20121120163956.GD17797@dm>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 16:39 +0000, Andy Whitcroft wrote:
> On Tue, Nov 20, 2012 at 07:51:17AM -0800, Joe Perches wrote:
> > On Tue, 2012-11-20 at 15:37 +0000, Andy Whitcroft wrote:
> > > Consolidate the if (foo) bar(foo) detectors into a single check.  Add
> > > debugfs_remove and family.
> > > 
> > > Based on a patch by Constantine Shulyupin <const@MakeLinux.com>.
> > []
> > > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > []
> > >  
> > > +# check for needless "if (<foo>) fn(<foo>)" uses
> > > +		if ($prevline =~ /\bif\s*\(\s*($Lval)\s*\)/) {
> > > +			my $expr = '\s*\(\s*' . quotemeta($1) . '\s*\)\s*;';
> > > +
> > []
> > > +# check for needless debugfs_remove() and debugfs_remove_recursive*() checks
> > 
> > Hey Andy, that's an incomplete comment.
> > Just remove it.
> 
> Oh it is meant to drop next to the other comments from the preceeding
> hunks which are being removed, it should end up looking like this:
> 
> # check for needless kfree() checks
> # check for needless usb_free_urb() checks
> # check for needless debugfs_remove() and debugfs_remove_recursive*() checks
> 
> Admitedly the trailing checks on each are a little redundant, but it is
> intended to retain the list of functions affected.

I think all of those are unnecessary.
Self documenting code is better right?

If not, I'd remove the "check for needless", leave the function,
and remove the trailing "checks"

btw: the * after debugfs_remove_recursive should be removed too.

cheers, Joe

