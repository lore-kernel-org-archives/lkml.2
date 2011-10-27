Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1J0U3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 16:29:05 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50217 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752661Ab1J0U3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 16:29:04 -0400
Message-ID: <1319747342.7969.15.camel@Joe-Laptop>
Subject: Re: [PATCH] checkpatch: improve error message for p1-check
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Andy Whitcroft <apw@canonical.com>
Date: Thu, 27 Oct 2011 13:29:02 -0700
In-Reply-To: <alpine.DEB.2.00.1110271309050.7639@chino.kir.corp.google.com>
References: <1319027583-17842-1-git-send-email-w.sang@pengutronix.de>
	 <alpine.DEB.2.00.1110261329240.23111@chino.kir.corp.google.com>
	 <1319669467.21924.18.camel@Joe-Laptop>
	 <alpine.DEB.2.00.1110261607150.6982@chino.kir.corp.google.com>
	 <1319670886.21924.22.camel@Joe-Laptop>
	 <alpine.DEB.2.00.1110261633190.19579@chino.kir.corp.google.com>
	 <1319672648.21924.26.camel@Joe-Laptop>
	 <alpine.DEB.2.00.1110271309050.7639@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-27 at 13:11 -0700, David Rientjes wrote:
> On Wed, 26 Oct 2011, Joe Perches wrote:
> > > I mean it only makes sense if both prefixes exist (otherwise patch and 
> > > git-apply will assume it's not a -p0 patch).
> > I think we should not care about the prefixes at all,
> > only whether or not the patched file exists.
> Nack,

Hi David.

It might be better if you would submit patches
to checkpatch before you nack others.

How about you track the --- and +++ lines and
submit a suggested patch yourself?

> there's nothing wrong with storing original files that you're 
> modifying in a subdirectory with a name of your choice in the kernel tree.  

Just as there's nothing wrong with storing original
and modified versions of subdirectories too.

> It doesn't imply a -p0 patch unless both prefixes appear and that's the 
> best indication that it appears in both the patch author and patch 
> applier's tree whereas the file being modified is ambiguous.

There's no single perfect test and it's just a silly
warning anyway.

I think the most common case is the direct editing of
a single file and production of a diff to submit as
a patch.
 
$ emacs <file>
# make changes, save original as ~ backup
$ diff -urN <file>~ <file> > ./foo.diff
$ make mrproper; make allyesconfig ; make
# deletes backup files
$ ./scripts/checkpatch.pl foo.diff

I didn't bother even finding out why the message
was emitted for me even though I had a b temp
directory in my tree.  I just ignored it.

cheers, Joe

