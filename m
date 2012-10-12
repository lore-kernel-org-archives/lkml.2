Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab2JLLxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:53:13 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:37604 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758361Ab2JLLxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:53:10 -0400
Date: Fri, 12 Oct 2012 13:52:58 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Thomas Lendacky <tahm@linux.vnet.ibm.com>, avi@redhat.com
Subject: Re: [PATCH 0/3] virtio-net: inline header support
Message-ID: <20121012135258.75ca3310@BR9GNB5Z>
In-Reply-To: <87wqyw63et.fsf@rustcorp.com.au>
References: <506C192E.5060700@redhat.com>
	<87bogj2j1b.fsf@rustcorp.com.au>
	<506D3610.7000103@redhat.com>
	<87ipaq1jtt.fsf@rustcorp.com.au>
	<506D8DD5.20904@redhat.com>
	<87391t1nkq.fsf__40391.6521034718$1349505001$gmane$org@rustcorp.com.au>
	<507029EB.2050405@redhat.com>
	<878vbg8cma.fsf@rustcorp.com.au>
	<5073D1D8.3060905@redhat.com>
	<87k3ux98oc.fsf@rustcorp.com.au>
	<20121011110430.GF5552@redhat.com>
	<87wqyw63et.fsf@rustcorp.com.au>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12101211-0342-0000-0000-00000314F1B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012 09:07:46 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> "Michael S. Tsirkin" <mst@redhat.com> writes:
> > On Thu, Oct 11, 2012 at 10:33:31AM +1030, Rusty Russell wrote:
> >> OK.  Well, Anthony wants qemu to be robust in this regard, so I am
> >> tempted to rework all the qemu drivers to handle arbitrary layouts.
> >> They could use a good audit anyway.
> >
> > I agree here. Still trying to understand whether we can agree to use
> > a feature bit for this, or not.
> 
> I'd *like* to imply it by the new PCI layout, but if it doesn't work
> we'll add a new feature bit.
> 
> I'm resisting a feature bit, since it constrains future implementations
> which could otherwise assume it.
> 
> >> This would become a glaring exception, but I'm tempted to fix it to 32
> >> bytes at the same time as we get the new pci layout (ie. for the virtio
> >> 1.0 spec).
> >
> > But this isn't a virtio-pci only issue, is it?
> > qemu has s390 bus with same limmitation.
> > How can we tie it to pci layout?
> 
> They can use a transport feature if they need to, of course.  But
> perhaps the timing with ccw will coincide with the fix, in which they
> don't need to, but it might be a bit late.
> 
> Cornelia?

My virtio-ccw host code is still going through a bit of rework, so it
might well go in after the fix.

There's also the existing (non-spec'ed) s390-virtio transport. While it
will likely be deprecated sometime in the future, it should probably
get a feature bit for consistency's sake.

> 
> Cheers,
> Rusty.
> 

