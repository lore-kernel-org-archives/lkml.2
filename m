Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab2FDEtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:49:35 -0400
Received: from ozlabs.org ([203.10.76.45]:57938 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756013Ab2FDEsl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:48:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Josh Boyer <jwboyer@gmail.com>
Cc: David Howells <dhowells@redhat.com>, kyle@mcmartin.ca,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
In-Reply-To: <CA+5PVA5qCiYNppOBihKfsqvyNWwBsBsyGD7SmJaphV_67HG1aQ@mail.gmail.com>
References: <8762blyedn.fsf@rustcorp.com.au> <87obpfxdpr.fsf@rustcorp.com.au> <20120522230218.24007.3556.stgit@warthog.procyon.org.uk> <7474.1337782847@redhat.com> <5107.1337868051@redhat.com> <87r4u6w58c.fsf@rustcorp.com.au> <CA+5PVA5qCiYNppOBihKfsqvyNWwBsBsyGD7SmJaphV_67HG1aQ@mail.gmail.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 04 Jun 2012 10:46:01 +0930
Message-ID: <87lik33mi6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012 11:35:23 -0400, Josh Boyer <jwboyer@gmail.com> wrote:
> On Sun, May 27, 2012 at 1:41 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Thu, 24 May 2012 15:00:51 +0100, David Howells <dhowells@redhat.com> wrote:
> >> > > Why would you want multiple signatures?  That just complicates things.
> >> >
> >> > The code above stays pretty simple; if the signature fails, you set size
> >> > to i, and loop again.  As I said, if you know exactly how you're going
> >> > to strip the modules, you can avoid storing the stripped module and
> >> > simply append both signatures.
> >>
> >> You still haven't justified it.  One of your arguments about rejecting the ELF
> >> parsing version was that it was too big for no useful extra value that I could
> >> justify.  Supporting multiple signatures adds extra size and complexity for no
> >> obvious value.
> >
> > One loop is a lot easier to justify that the ELF-parsing mess.  And it
> > can be done in a backwards compatible way tomorrow: old kernels will
> > only check the last signature.
> >
> > I had assumed you'd rather maintain a stable strip util which you can
> > use on kernel modules than rework your module builds.  I guess not.
> 
> Could you elaborate on this part a bit?  Do you mean integrate a
> standalone strip utility in the kernel sources and maintain that for
> use during module builds?  Or am I misunderstanding and you meant
> something else?

In the kernel sources, no.  But could RH maintain such a thing?  Surely.

Whether they want to guarantee that their strip is stable on kernel
modules, or create a minimal 'kmod-strip' is up to them.

> I can see how that sounds simple and desirable from one aspect, but
> it seems somewhat odd to me to duplicate the existing (or create from
> scratch) strip utilities.

Mangling a module after it is signed is very odd, and odd things aren't
nice for security features.  That's how we got here; I'm trying to move
the oddness out of the verification path.

Cheers,
Rusty.
