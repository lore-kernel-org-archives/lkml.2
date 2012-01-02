Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab2ABQSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 11:18:11 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53392
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728Ab2ABQSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 11:18:10 -0500
Date: Mon, 2 Jan 2012 11:18:03 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to BIO
Message-ID: <20120102161803.GA32365@infradead.org>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
 <CAJSP0QW5wPYcHr02oNm8Y8=hsChEb5tJuO0ntPy9MO8EPuH=Qg@mail.gmail.com>
 <20111222234135.GB7056@barrios-laptop.redhat.com>
 <CAJSP0QWpzOGtQEULu7yz1vDEExSatGpdEPSvvDx=oNYkBveyrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QWpzOGtQEULu7yz1vDEExSatGpdEPSvvDx=oNYkBveyrQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 01, 2012 at 04:45:42PM +0000, Stefan Hajnoczi wrote:
> win.  The fact that you added batching suggests there is some benefit
> to what the request-based code path does.  So find out what's good
> about the request-based code path and how to get the best of both
> worlds.

Batching pretty much always is a winner.  The maximum bio size is small
enough that we'll frequently see multiple contiguos bios.  Because of
that the Md layer fo example uses the same kind of batching.  I've tried
to make this more general by passing a bio list to ->make_request and
make the on-stack plugging work on bios, but in the timeslice I had
available for that I didn't manage to actually make it work.

