Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab1KBEy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 00:54:59 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56307 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab1KBEy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 00:54:56 -0400
Subject: Re: [PULL] virtio
From: Sasha Levin <levinsasha928@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
In-Reply-To: <8739e7uy87.fsf@rustcorp.com.au>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
	 <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy>
	 <20111101124223.GA14060@redhat.com>  <8739e7uy87.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 02 Nov 2011 06:52:44 +0200
Message-ID: <1320209564.9173.6.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 11:39 +1030, Rusty Russell wrote:
> On Tue, 1 Nov 2011 14:42:23 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Tue, Nov 01, 2011 at 02:33:33PM +0200, Sasha Levin wrote:
> > > Unless Michael pointed this patch out, it would have broken (at least)
> > > the kvm tool in a non obvious way which would require a rather long
> > > session of 'git bisect' to figure out whats wrong.
> 
> I assumed not, until QEMU provided the second BAR it would simply fall
> back.  Or am I completely misunderstanding?

QEMU uses two bars within each virtio-pci device. First one (BAR 0) is
the PIO config BAR, and the second one (BAR 1) is the MSI-X BAR used for
the MSI-X table and the PBA.

Since the PCI spec allows you to have the MSI-X table and the PBA in
completely different regions pointed by two different BARs, we did so in
kvm tools and have BAR 1 pointing to the MSI-X table, and BAR 2 pointing
to the PBA ( - we *already* provided the second BAR and used it for
something else).

This means that with this patch, we'd load BAR 2 and use it as the
config space, instead of the PBA table which it really represents.

-- 

Sasha.

