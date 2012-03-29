Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab2C2ILU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:11:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40866 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab2C2ILQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:11:16 -0400
Message-ID: <4F7418D8.40900@kernel.dk>
Date: Thu, 29 Mar 2012 10:10:00 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Amit Shah <amit.shah@redhat.com>, Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] virtio-blk: Call revalidate_disk() upon online disk resize
References: <20120328203200.GE3376@redhat.com>
In-Reply-To: <20120328203200.GE3376@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2012 10:32 PM, Vivek Goyal wrote:
> If a virtio disk is open in guest and a disk resize operation is done,
> (virsh blockresize), new size is not visible to tools like "fdisk -l".
> This seems to be happening as we update only part->nr_sects and not
> bdev->bd_inode size.
> 
> Call revalidate_disk() which should take care of it. I tested growing disk
> size of already open disk and it works for me.

Thanks, obviously right. Applied.

-- 
Jens Axboe

