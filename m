Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab1LSGIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 01:08:30 -0500
Received: from ozlabs.org ([203.10.76.45]:41211 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab1LSGH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 01:07:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "Luis R. Rodriguez" <mcgrof@frijolero.org>,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Greg KH <greg@kroah.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC] modpost: add option to allow external modules to avoid taint
In-Reply-To: <1324010389.2825.265.camel@deadeye>
References: <1323752547.2825.101.camel@deadeye> <1323879603-2961-1-git-send-email-linville@tuxdriver.com> <87mxatp3ty.fsf@rustcorp.com.au> <1324010389.2825.265.camel@deadeye>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 19 Dec 2011 16:15:45 +1030
Message-ID: <87k45tnmgm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Dec 2011 04:39:49 +0000, Ben Hutchings <ben@decadent.org.uk> wrote:
Non-text part: multipart/signed
> On Fri, 2011-12-16 at 14:26 +1030, Rusty Russell wrote:
> > On Wed, 14 Dec 2011 11:20:03 -0500, "John W. Linville" <linville@tuxdriver.com> wrote:
> > We really want to indicate "out-of-support" which is only a 1:1
> > mapping to out-of-tree for upstream kernels.
> 
> Who are 'we' in this instance?

Whoever turns this flag on.  I was using friendly, inclusive language :)

> > How does Debian handle this?
> 
> All the modules in Debian's kernel binary packages are built in-tree.
> Backported modules are patched in as necessary.
> 
> Debian includes many packages of OOT modules, but those are supported by
> their respective maintainers and not the kernel team.  So for the kernel
> team, the 'O' flag does not mean 'unsupported' but may indicate that
> another maintainer should handle the bug (or it may also be irrelevant
> to the bug).

So, in your case, the kernel team want to know what's outside their
support, so this flag works well for you.

As John pointed out, it's a bit useless for them.  We could enable it
with a config option, or they could ignore it, since they're going to
module-signing route anyway.

> > Perhaps it makes more sense to use the proposed module signing stuff in
> > a simplified mode to mark built-with-kernel modules (eg. just put the
> > sha of known modules inside the kernel).
> 
> Unlike commercial distributions, no-one is paying Debian for support
> contracts and no-one can game the system by hiding OOT modules.  So it's
> probably not worthwhile for us to use module signing at all.
> 
> However, supposing we did go down this route, I would guess that
> checksums for ~3000 modules take up more space than the signature
> checking code.  Instead, we could perhaps generate a key pair during
> build, include the public key in the kernel and then discard the private
> key.  (But getting entropy would likely be a problem for the key
> generation.)

Agreed, 60k is a bit expensive for this minor feature.  

Thanks,
Rusty.
