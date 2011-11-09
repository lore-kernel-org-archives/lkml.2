Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab1KIM36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:29:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60530 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1KIM34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:29:56 -0500
Subject: Re: [PATCH RFC] virtio-spec: flexible configuration layout
From: Sasha Levin <levinsasha928@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        avi@redhat.com, penberg@cs.helsinki.fi
In-Reply-To: <alpine.LFD.2.02.1111091421570.4936@tux.localdomain>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
	 <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy>
	 <20111101124223.GA14060@redhat.com> <8739e7uy87.fsf@rustcorp.com.au>
	 <20111102233110.GA20289@redhat.com> <20111108214021.GA4538@redhat.com>
	 <1320828366.31056.16.camel@lappy> <20111109101318.GB20612@redhat.com>
	 <alpine.LFD.2.02.1111091421570.4936@tux.localdomain>
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 09 Nov 2011 14:28:03 +0200
Message-ID: <1320841683.31056.41.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 14:25 +0200, Pekka Enberg wrote:
> On Wed, 9 Nov 2011, Michael S. Tsirkin wrote:
> >> KVM tool actually has support for 64bit features, we can probably remove
> >> that when Pekka isn't looking :)
> >
> > It's not yet released so maybe it's not an issue yet.
> > If it's too late I can re-add them to legacy too.
> >
> > Pekka, 64 features aren't yet used and we are discussing
> > changing the layout for that field. Mind taking it out
> > of kvm tool for now?
> 
> Sasha, why did we add 64-bit features to the KVM tool? Wasn't it part of 
> the virtio spec? Does QEMU not use them? How badly will older versions of 
> the KVM tool break if you drop 64-bit features?

We added 64-bit features to the tool because it just got into the spec
when we rewrote our virtio-pci handling - so we just implemented the
updated spec.

QEMU doesn't use them since while it did get into the spec, it was
intended to future-proof the limited feature bits, so no one really
needed them yet.

They don't exist in kernel code either, for same reason as above.

Nothing will break if we remove it since no one really used it, we were
probably the first and only implementation of the spec which considered
them :)

-- 

Sasha.

