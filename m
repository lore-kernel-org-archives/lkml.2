Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945993Ab2KNXTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 18:19:32 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53182 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab2KNXTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 18:19:31 -0500
Date: Wed, 14 Nov 2012 23:24:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/Sandy Bridge: reserve pages when integrated
 graphics is present
Message-ID: <20121114232443.5c07b205@pyramind.ukuu.org.uk>
In-Reply-To: <20121114135534.653b70dd@jbarnes-desktop>
References: <1352925811-2598-1-git-send-email-jbarnes@virtuousgeek.org>
	<20121114211905.503f3701@pyramind.ukuu.org.uk>
	<20121114135534.653b70dd@jbarnes-desktop>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012 13:55:34 -0800
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Wed, 14 Nov 2012 21:19:05 +0000
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > On Wed, 14 Nov 2012 20:43:31 +0000
> > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > 
> > > SNB graphics devices have a bug that prevent them from accessing certain
> > > memory ranges, namely anything below 1M and in the pages listed in the
> > > table.  So reserve those at boot if set detect a SNB gfx device on the
> > > CPU to avoid GPU hangs.
> > 
> > What happens if the other addresses map to an external memory object - eg
> > a PCI device which is a legitimate DMA source for video overlay etc ?
> 
> Other addresses as in the 5 pages high in the address space?  I'm not
> sure how to do what I want with memblock, doesn't it just allocate RAM
> not I/O space?... /me looks at the memblock API
> 
> Or do you mean if we map GTT pages to point at some non-RAM region will
> SNB gfx be able to decode them?  If that's the question, then I think
> the answer is no, but I don't have enough detail on the hw bug to be
> certain.
> 
> > I assume this is just for GPU fetches from main memory ?
> 
> AIUI, it's an address decoder bug, so it would affect any fetch by the
> GPU through its memory interface glue.

Well the extreme case (and I suspect one we don't care about too much in
reality) is a box with a PCI/E or similar MMIO graphics device which is
taking part in Dave Airlie's wonderous new graphics architecture so being
rendered into or fetched by the Intel GPU and whose PCI/E space is mapped
crossing one of those addresses.

The other case of concern would be if the Intel IOMMU had mappings there
that were then touched in some way by the GPU ?

Alan
