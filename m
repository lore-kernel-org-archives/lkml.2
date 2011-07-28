Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1G1Orr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 10:47:47 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47224
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676Ab1G1Orp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 10:47:45 -0400
Date: Thu, 28 Jul 2011 10:47:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Liu Yuan <namei.unix@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] vhost-blk: An in-kernel accelerator for virtio-blk
Message-ID: <20110728144740.GA26744@infradead.org>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
 <1311863346-4338-2-git-send-email-namei.unix@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311863346-4338-2-git-send-email-namei.unix@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 10:29:05PM +0800, Liu Yuan wrote:
> From: Liu Yuan <tailai.ly@taobao.com>
> 
> Vhost-blk driver is an in-kernel accelerator, intercepting the
> IO requests from KVM virtio-capable guests. It is based on the
> vhost infrastructure.
> 
> This is supposed to be a module over latest kernel tree, but it
> needs some symbols from fs/aio.c and fs/eventfd.c to compile with.
> So currently, after applying the patch, you need to *recomplie*
> the kernel.
> 
> Usage:
> $kernel-src: make M=drivers/vhost
> $kernel-src: sudo insmod drivers/vhost/vhost_blk.ko
> 
> After insmod, you'll see /dev/vhost-blk created. done!

You'll need to send the changes for existing code separately.

If you're going mostly for raw blockdevice access just calling
submit_bio will shave even more overhead off, and simplify the
code a lot.
