Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1G2Kzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:55:49 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47054
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755180Ab1G2Kzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:55:48 -0400
Date: Fri, 29 Jul 2011 06:55:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Liu Yuan <namei.unix@gmail.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khoa Huynh <khoa@us.ibm.com>, Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block
 device
Message-ID: <20110729105540.GA16250@infradead.org>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
 <CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>
 <CAJSP0QVH8RgwdtVRtowbkJ0KHiDs8np=mcfP8LWX6=NdDsAJcQ@mail.gmail.com>
 <4E326879.9050009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E326879.9050009@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 03:59:53PM +0800, Liu Yuan wrote:
> I noted bdrv_aio_multiwrite() do the murging job, but  I am not sure

Just like I/O schedulers it's actually fairly harmful on high IOPS,
low latency devices.  I've just started doing a lot of qemu bencharks,
and disabling that multiwrite mess alone gives fairly nice speedups.

The major issue seems to be additional memory allocations and cache
lines - a problem that actually is fairly inherent all over the qemu
code.

