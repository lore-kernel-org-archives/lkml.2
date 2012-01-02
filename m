Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2ABQPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 11:15:40 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53385
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728Ab2ABQPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 11:15:37 -0500
Date: Mon, 2 Jan 2012 11:15:18 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to BIO
Message-ID: <20120102161518.GA28940@infradead.org>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
 <CAJSP0QW5wPYcHr02oNm8Y8=hsChEb5tJuO0ntPy9MO8EPuH=Qg@mail.gmail.com>
 <20111222234135.GB7056@barrios-laptop.redhat.com>
 <CAJSP0QWpzOGtQEULu7yz1vDEExSatGpdEPSvvDx=oNYkBveyrQ@mail.gmail.com>
 <4F01D750.7040304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F01D750.7040304@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 05:12:00PM +0100, Paolo Bonzini wrote:
> On 01/01/2012 05:45 PM, Stefan Hajnoczi wrote:
> >By the way, drivers for solid-state devices can set QUEUE_FLAG_NONROT
> >to hint that seek time optimizations may be sub-optimal.  NBD and
> >other virtual/pseudo device drivers set this flag.  Should virtio-blk
> >set it and how does it affect performance?
> 
> By itself is not a good idea in general.
> 
> When QEMU uses O_DIRECT, the guest should not use QUEUE_FLAG_NONROT
> unless it is active for the host disk as well.  (In doubt, as is the
> case for remote hosts accessed over NFS, I would also avoid NONROT
> and allow more coalescing).

Do we have any benchmark numbers where QUEUE_FLAG_NONROT makes a
difference?  I tried a few times, and the only constant measureable
thing was that it regressed performance when used for rotating devices
in a few benchmarks.

