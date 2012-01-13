Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab2AMDZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 22:25:13 -0500
Received: from ozlabs.org ([203.10.76.45]:33111 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab2AMDZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 22:25:10 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Shah <amit.shah@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Davidlohr Bueso <dave@gnu.org>, Jacek Galowicz <jacek@galowicz.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Stratos Psomadakis <psomas@cslab.ece.ntua.gr>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PULL] virtio and lguest
In-Reply-To: <CA+55aFyOy4bWUq6PH3ThM2CXOFwi75FE8HGOJ8DNZjFWw9rq6A@mail.gmail.com>
References: <87lipd4hqx.fsf@rustcorp.com.au> <CA+55aFyOy4bWUq6PH3ThM2CXOFwi75FE8HGOJ8DNZjFWw9rq6A@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 13 Jan 2012 12:59:19 +1030
Message-ID: <87fwfkjpxc.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jan 2012 16:29:14 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, Jan 11, 2012 at 9:22 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> > Amit Shah (12):
> >      virtio: pci: switch to new PM API
> 
> Hmm. Afaik, this is broken, or at least not complete.
> 
> Sure, it switches to the new PM API, but it still does the PCI ops itself.
> 
> It should not need to - the PCI layer will do the power state and
> standard PCI device state saving. And setting the PCI_D3hot state when
> shared interrupts can still happen at suspend time is just a bad idea.
> 
> So I think you're doing extra work and introducing bugs by doing so -
> the default PCI bus operations should already do all you do, just do
> it better. And then you can use the SIMPLE_DEV_PM_OPS() to build the
> dev_pm_ops structure and get all the normal cases right automatically.
> 
> I don't know if there is any particularly good example of this, but
> you can see some of the network drivers for examples of this. Notice
> how they don't need to worry about PCI power states etc at all, they
> just need to worry about the actual chip suspend/resume (and for a
> network driver, you'd do the netif_device_detach/netif_device_attach
> etc)

Ok, I'll confess complete ignorance, and wait for Amit to respond.  I
must admit that PM for virtual devices is not a personal priority...

Thanks,
Rusty.
