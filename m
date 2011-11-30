Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab1K3ISH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 03:18:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab1K3ISG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 03:18:06 -0500
Date: Wed, 30 Nov 2011 10:14:42 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCHv3 RFC] virtio-pci: flexible configuration layout
Message-ID: <20111130081441.GF17781@redhat.com>
References: <20111122183621.GA5235@redhat.com>
 <87hb1v1scp.fsf@rustcorp.com.au>
 <20111123084640.GE22734@redhat.com>
 <87ty5uxso3.fsf@rustcorp.com.au>
 <20111124070728.GH29994@redhat.com>
 <87vcq5t69c.fsf@rustcorp.com.au>
 <1322471731.3577.10.camel@lappy>
 <87pqgats49.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pqgats49.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 10:10:22AM +1030, Rusty Russell wrote:
> On Mon, 28 Nov 2011 11:15:31 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> > On Mon, 2011-11-28 at 11:25 +1030, Rusty Russell wrote:
> > > I'd like to see kvmtools remove support for legacy mode altogether,
> > > but they probably have existing users.
> > 
> > While we can't simply remove it right away, instead of mixing our
> > implementation for both legacy and new spec in the same code we can
> > split the virtio-pci implementation into two:
> > 
> > 	- virtio/virtio-pci-legacy.c
> > 	- virtio/virtio-pci.c
> > 
> > At that point we can #ifdef the entire virtio-pci-legacy.c for now and
> > remove it at the same time legacy virtio-pci is removed from the kernel.
> 
> Hmm, that might be neat, but we can't tell the driver core to try
> virtio-pci before virtio-pci-legacy, so we need detection code in both
> modules (and add a "force" flag to virtio-pci-legacy to tell it to
> accept the device even if it's not a legacy-only one).

This flag might need to be per device ideally, which is tricky ...

> 
> Then it should work...
> Cheers,
> Rusty.

One also wonders whether and how this will work on other OS-es.

-- 
MST
