Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab2DIH4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 03:56:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab2DIH4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 03:56:12 -0400
Date: Mon, 9 Apr 2012 10:53:18 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Kay Sievers <kay.sievers@vrfy.org>,
        Tokunaga Kei <tokunaga.keiich@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        UDEV <linux-hotplug@vger.kernel.org>
Subject: Re: [RFC PATCH] virtio_blk: Checking "private_data"  to avoid kernel
 panic when hotplugging
Message-ID: <20120409075318.GB27771@redhat.com>
References: <4F728831.2090406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F728831.2090406@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 11:40:33AM +0800, Ren Mingxin wrote:
>  Hi,
> 
> On guest with upstream's kernel(3.3.0-rc7), I
> mounted virtblk as:
>   a) # mkfs /dev/vda
>   b) # mount /dev/vda /mnt
>   c) # cd /mnt
> 
> Then I did hotplug for virtblk via virsh on host as:
>   a) # sudo virsh detach-disk guest vda
>   b) # sudo virsh attach-disk guest /media/data/test.img vda
> 
> I encountered guest's kernel panic (*probability *
> *event*)whose backtrace liked this:

Any news here? Managed to trace?
Does this still happen with 3.4-rc2?
There's a chance you are hitting a race fixed by
4678d6f970c2f7c0cbfefc0cc666432d153b321b.

If it's still not fixed it might make sense to enable slab debugging -
we might have a use after free here.

-- 
MST
