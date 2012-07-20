Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab2GTTaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 15:30:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab2GTTaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 15:30:15 -0400
Date: Fri, 20 Jul 2012 22:30:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Asias He <asias@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jeff Moyer <jmoyer@redhat.com>, kvm@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH RESEND 0/5] Add vhost-blk support
Message-ID: <20120720193035.GA20031@redhat.com>
References: <1342169711-12386-1-git-send-email-asias@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342169711-12386-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 04:55:06PM +0800, Asias He wrote:
> 
> Hi folks,
> 
> [I am resending to fix the broken thread in the previous one.]
> 
> This patchset adds vhost-blk support. vhost-blk is a in kernel virito-blk
> device accelerator. Compared to userspace virtio-blk implementation, vhost-blk
> gives about 5% to 15% performance improvement.
> 
> Asias He (5):
>   aio: Export symbols and struct kiocb_batch for in kernel aio usage
>   eventfd: Export symbol eventfd_file_create()
>   vhost: Make vhost a separate module
>   vhost-net: Use VHOST_NET_FEATURES for vhost-net
>   vhost-blk: Add vhost-blk support


OK so given the state it's in, and assuming you think it is helpful
to let it mature in tree and not out of tree, I think it's
reasonable to try to do it like tcm_vhost is going to do it:
- send me changes to vhost core ASAP (and keep it minimal, e.g.
  use your own header file to export to userspace)
- for other stuff - put in drivers/staging, and ask Greg to merge

-- 
MST
