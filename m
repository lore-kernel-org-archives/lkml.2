Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1JSKzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 06:55:21 -0400
Received: from lvk-gate.cmc.msu.ru ([212.192.248.233]:59496 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753665Ab1JSKzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 06:55:20 -0400
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: RKK <kulkarni.ravi4@gmail.com>
Subject: Re: high-order allocation + highmem + streaming DMA - possible?
Date: Wed, 19 Oct 2011 14:55:13 +0400
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stefan@lvk.cs.msu.su
References: <201110191045.42613@zigzag.lvk.cs.msu.su> <CAM=x7SYGE50C7BHuEcSGpkC+aSPB143wYODktzEj4QsKcsRvMg@mail.gmail.com>
In-Reply-To: <CAM=x7SYGE50C7BHuEcSGpkC+aSPB143wYODktzEj4QsKcsRvMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201110191455.15540@zigzag.lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hello.
> >
> > We are writing a driver for a custom PCI device that receives large
> > amount of data.
> >
> > Device is capable of DMAing received data in 64k chunks.
> >
> > We have been going to:
> > - use physically-continuous 64k-sized memory areas using alloc_pages()
> > with order=4,
> > - allocate large number of such areas on driver init,
> > - implement mmap() to map those all to userspace for zero-copy
> > processing, - use streaming DMA to actually receive data
>
>   May i know why u want to mmap to userspace instead of using a
> device? performance is affected by a large amount if u use mmap

mmap() is done once, at initialization time, for entire data buffer.
Later data is processed in zero-copy pattern.
I believe it is fastest possible solution.

> > Is there a way to use streaming DMA with large memory areas located in
> > highmem?
>
> I dont think DMA is available for highmem? Not sure though . never saw
> a usecase for it.

DMA is definitly available for highmem on per-page basis.
I'm interested in DMA of larger blocks.

Nikita
