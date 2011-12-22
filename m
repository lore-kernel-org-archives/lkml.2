Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1LVXlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 18:41:50 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51994 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab1LVXlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 18:41:44 -0500
Date: Fri, 23 Dec 2011 08:41:35 +0900
From: Minchan Kim <minchan@kernel.org>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to BIO
Message-ID: <20111222234135.GB7056@barrios-laptop.redhat.com>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
 <CAJSP0QW5wPYcHr02oNm8Y8=hsChEb5tJuO0ntPy9MO8EPuH=Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJSP0QW5wPYcHr02oNm8Y8=hsChEb5tJuO0ntPy9MO8EPuH=Qg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 12:57:40PM +0000, Stefan Hajnoczi wrote:
> On Wed, Dec 21, 2011 at 1:00 AM, Minchan Kim <minchan@kernel.org> wrote:
> > This patch is follow-up of Christohp Hellwig's work
> > [RFC: ->make_request support for virtio-blk].
> > http://thread.gmane.org/gmane.linux.kernel/1199763
> >
> > Quote from hch
> > "This patchset allows the virtio-blk driver to support much higher IOP
> > rates which can be driven out of modern PCI-e flash devices.  At this
> > point it really is just a RFC due to various issues."
> 
> Basic question to make sure I understood this series: does this patch
> bypass the guest I/O scheduler (but then you added custom batching
> code into virtio_blk.c)?

Right.

> 
> If you're stumped by the performance perhaps compare blktraces of the
> request approach vs the bio approach.  We're probably performing I/O
> more CPU-efficiently but the I/O pattern itself is worse.

You mean I/O scheduler have many techniques to do well in I/O pattern?
That's what I want to discuss in this RFC.

I guess request layer have many techniques proved during long time
to do well I/O but BIO-based drvier ignores them for just reducing locking
overhead. Of course, we can add such techniques to BIO-batch driver like 
custom-batch in this series. But it needs lots of work, is really duplication,
and will have a problem on maintenance.

I would like to listen opinions whether this direction is good or bad.

> 
> Stefan

-- 
Kind regards,
Minchan Kim
