Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1LADRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:17:20 -0500
Received: from ozlabs.org ([203.10.76.45]:35838 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab1LADRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:17:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCHv3 RFC] virtio-pci: flexible configuration layout
In-Reply-To: <1322658763.3985.4.camel@lappy>
References: <20111122183621.GA5235@redhat.com> <87hb1v1scp.fsf@rustcorp.com.au> <20111123084640.GE22734@redhat.com> <87ty5uxso3.fsf@rustcorp.com.au> <20111124070728.GH29994@redhat.com> <87vcq5t69c.fsf@rustcorp.com.au> <1322471731.3577.10.camel@lappy> <87pqgats49.fsf@rustcorp.com.au> <1322658763.3985.4.camel@lappy>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 01 Dec 2011 13:12:42 +1030
Message-ID: <87vcq1rp0d.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011 15:12:43 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Wed, 2011-11-30 at 10:10 +1030, Rusty Russell wrote:
> > On Mon, 28 Nov 2011 11:15:31 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> > > On Mon, 2011-11-28 at 11:25 +1030, Rusty Russell wrote:
> > > > I'd like to see kvmtools remove support for legacy mode altogether,
> > > > but they probably have existing users.
> > > 
> > > While we can't simply remove it right away, instead of mixing our
> > > implementation for both legacy and new spec in the same code we can
> > > split the virtio-pci implementation into two:
> > > 
> > > 	- virtio/virtio-pci-legacy.c
> > > 	- virtio/virtio-pci.c
> > > 
> > > At that point we can #ifdef the entire virtio-pci-legacy.c for now and
> > > remove it at the same time legacy virtio-pci is removed from the kernel.
> > 
> > Hmm, that might be neat, but we can't tell the driver core to try
> > virtio-pci before virtio-pci-legacy, so we need detection code in both
> > modules (and add a "force" flag to virtio-pci-legacy to tell it to
> > accept the device even if it's not a legacy-only one).
> 
> I was thinking more in the direction of fallback code in virtio-pci.c to
> virtio-pci-legacy.c.
> 
> Something like:
> #ifdef VIRTIO_PCI_LEGACY
> [Create BAR0 and map it to virtio-pci-legacy.c]
> #endif
> 
> So BAR0 isn't defined as long as legacy code is there, which makes
> falling back to legacy pretty simple.

But it's nicer to see the driver actually labelled "virtio-pci-legacy",
and such a module.

I'll code something up, see what it looks like.

Cheers,
Rusty.
