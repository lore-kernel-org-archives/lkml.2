Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1KACRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 22:17:19 -0400
Received: from ozlabs.org ([203.10.76.45]:38797 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab1KACRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 22:17:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Hutchings <ben@decadent.org.uk>, Jason Baron <jbaron@redhat.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, Greg KH <greg@kroah.com>,
        Dave Jones <davej@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 2/2] module: Re-enable dynamic debugging for GPL-compatible OOT modules
In-Reply-To: <1320068657.6759.107.camel@deadeye>
References: <1319773094.6759.32.camel@deadeye> <87obwxq5tz.fsf@rustcorp.com.au> <1320068657.6759.107.camel@deadeye>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 01 Nov 2011 12:39:46 +1030
Message-ID: <87r51svbit.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Oct 2011 13:44:17 +0000, Ben Hutchings <ben@decadent.org.uk> wrote:
Non-text part: multipart/signed
> On Mon, 2011-10-31 at 12:29 +1030, Rusty Russell wrote:
> > On Fri, 28 Oct 2011 04:38:14 +0100, Ben Hutchings <ben@decadent.org.uk> wrote:
> > > Dynamic debugging was enabled for GPL-compatible out-of-tree modules
> > > until my addition of TAINT_OOT_MODULE.  It should continue to be
> > > enabled now.
> > 
> > Please just remove the test entirely.
> > 
> > AFAICT there's nothing unique to dynamic debug which means it should
> > avoid taint.  If it oopses, we'll learn all about tainting in the oops
> > message.
> 
> It looks like the dynamic debug facility is not meant to be available to
> proprietary modules.

That was my guess too, but Mathieu (the author) said it was about
malformed modules:

On Wed, 26 Oct 2011 02:15:21 -0400:
> This check for tainted modules was first introduced with markers, and
> then used by tracepoints, and then also by dynamic debug. The rationale
> for this check was mainly to ensure that the marker/tracepoint code
> would not trigger a crash when loading a module with incompatible module
> header, originally compiled for an older kernel, into a newer kernel.
> This problem would happen even if the said module does not contain any
> marker/tracepoint, because we happen to try to use fields that are
> non-existent in the module header.

This is pretty bogus: since they forced the module in the first place,
they can handle the explosion.

So we should drop it altogether.

Thanks,
Rusty.
