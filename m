Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab2GYLUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:20:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468Ab2GYLUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:20:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAHO5Pa2ck_wqUwiuFUxEeU=k3dJvByyjpygpUhrSFRsMyBZ8Eg@mail.gmail.com>
References: <CAHO5Pa2ck_wqUwiuFUxEeU=k3dJvByyjpygpUhrSFRsMyBZ8Eg@mail.gmail.com> <20120720215636.14854.41208.stgit@warthog.procyon.org.uk> <CAHO5Pa0NOUk=Z8SNQ9t=Oi6aU96o-JtMuAytAoXJ2v1L0ntNww@mail.gmail.com> <28702.1343135952@warthog.procyon.org.uk> <CAHO5Pa310CYFKvyN4N21CHoCKJG-eJ04Q-yg1VmgwvgR5N91Rg@mail.gmail.com> <6193.1343211798@warthog.procyon.org.uk>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, tglx@linutronix.de,
        mingo@kernel.org, davej@redhat.com
Subject: Re: [PATCH 00/13] UAPI header file split
Date: Wed, 25 Jul 2012 12:20:32 +0100
Message-ID: <12201.1343215232@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk.manpages@gmail.com> wrote:

> >> 2. EMPTY UAPI HEADERS
> >>
> >> Some of the resulting uapi header files are empty:
> >> ...
> >> I imagine this should be reasonably easy to fix.
> >
> > Fix how?  The Kbuild files say these headers must exist in UAPI space, but
> > the __KERNEL__ guards therein don't define any content for them in UAPI.
> 
> I'm not sure of the answer here. It certainly seems odd to have a
> bunch of new empty header files in the kernel tree, which is why I
> commented on it. Without digging much deeper, I've no idea whether the
> Kbuild files can be (automatically?) modified not to require these
> empty files.

You can't get rid of the empty header files completely.  They're exported to
userspace and so userspace may require their presence.

I could put a guard in there just so they're not empty, I suppose.

> So, a manual fix may be in order?

Or just apply the removal regexp to each line before I write the UAPI header
out.  I'll have a play with it later.

David
