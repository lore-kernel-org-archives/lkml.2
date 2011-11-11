Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab1KKNHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 08:07:09 -0500
Received: from service87.mimecast.com ([91.220.42.44]:57364 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775Ab1KKNHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 08:07:07 -0500
Subject: Re: [PATCHv2 RFC] virtio-spec: flexible configuration layout
From: Pawel Moll <pawel.moll@arm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Wang Sheng-Hui <shhuiw@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>,
        "penberg@kernel.org" <penberg@kernel.org>
In-Reply-To: <20111111125907.GB23902@redhat.com>
References: <20111101124223.GA14060@redhat.com>
	 <8739e7uy87.fsf@rustcorp.com.au> <20111102233110.GA20289@redhat.com>
	 <20111108214021.GA4538@redhat.com> <20111109195901.GA28155@redhat.com>
	 <1320870287.3730.6.camel@lappy> <20111109205208.GA28599@redhat.com>
	 <1320872248.3730.11.camel@lappy> <87aa83qoao.fsf@rustcorp.com.au>
	 <CA+1xoqeH3ErNCELD+NoJHz=eH6FtxersUffoJSj0yQx2o=4g0g@mail.gmail.com>
	 <20111111125907.GB23902@redhat.com>
Date: Fri, 11 Nov 2011 13:06:57 +0000
Message-ID: <1321016817.3259.389.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 11 Nov 2011 13:06:58.0241 (UTC) FILETIME=[CB2E0B10:01CCA072]
X-MC-Unique: 111111113070105001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also, an unrelated questions: With PIO, requests were ordered, which
> > means that if we wrote to the queue selector and then read from a
> > queue register we would read the correct queue info.
> > Is the same thing assured to us with MMIO?
> 
> For real PCI, reads do not bypass writes in PCI. However this
> is only true if both are MMIO or both PIO reads.
> I don't think the ordering of MMIO versus PIO is guaranteed.
> 
> On KVM, the kernel doesn't do anything to guarantee ordering.
> So you get the natural ordering of the CPU.
> 
> > If we write to a queue
> > selector and immediately read from queue info would we be reading the
> > right info, or is there the slight chance that it would get reordered
> > and we would be reading queue info first and writing to the selector
> > later?
> 
> The thing to realize is that write to queue selector with KVM is in the
> end performed by host. And reading queue info means that host will be
> reading the queue selector. So this is a write followed by read
> from the same address. AFAIK no CPUs can reorder such accesses,
> so you get the right info.

(As far as I understand all the complexity ;-) Memory mapped using
ioremap()-like functions should preserve access order. In case of ARM
architecture such memory region is defined (at the page tables level) as
a "device memory" (contrary to "normal memory") and the processor will
not try to be clever about it. I know next-to-nothing about x86, but I
suppose similar idea applies.

Cheers!

Paweł


