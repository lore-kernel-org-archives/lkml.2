Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1HAIM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 04:12:27 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33144
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708Ab1HAIMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 04:12:08 -0400
Date: Mon, 1 Aug 2011 04:12:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Liu Yuan <namei.unix@gmail.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khoa Huynh <khoa@us.ibm.com>
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block
 device
Message-ID: <20110801081201.GA26472@infradead.org>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
 <CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>
 <4E325F98.5090308@gmail.com>
 <4E32F7F2.4080607@us.ibm.com>
 <4E363DB9.70801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E363DB9.70801@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 01:46:33PM +0800, Liu Yuan wrote:
> >- I focused on using vfs interfaces in the kernel, so that I can
> >use it for file-backed devices.
> >Our use-case scenario is mostly file-backed images.
> >
> vhost-blk's that uses Linux AIO also support file-backed images.
> Actually, I have run Guests both on raw partition and raw file
> images.

Note tjat it will only perform very well for preallocated images (just
like aio=native in qemu) - if you use sparse images it will have to
call into the allocator, which blocks for metadata I/O even in aio mode.

