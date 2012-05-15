Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2EOGWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 02:22:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46616 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab2EOGWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 02:22:52 -0400
Message-ID: <4FB1F627.3080809@kernel.dk>
Date: Tue, 15 May 2012 08:22:31 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Szymon Gruszczynski <sz.gruszczynski@googlemail.com>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>,
        Al Viro <viro@zeniv.linux.org>
Subject: Re: [PATCH] block: fix buffer overflow when printing partition UUIDs
References: <20120509195848.GA961@redhat.com> <20120514210353.GJ2366@google.com>
In-Reply-To: <20120514210353.GJ2366@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2012 11:03 PM, Tejun Heo wrote:
> 6d1d8050b4bc8 "block, partition: add partition_meta_info to hd_struct"
> added part_unpack_uuid() which assumes that the passed in buffer has
> enough space for sprintfing "%pU" - 37 characters including '\0'.
> 
> Unfortunately, b5af921ec0233 "init: add support for root devices
> specified by partition UUID" supplied 33 bytes buffer to the function
> leading to the following panic with stackprotector enabled.
> 
>   Kernel panic - not syncing: stack-protector: Kernel stack corrupted in: ffffffff81b14c7e
> 
>   [<ffffffff815e226b>] panic+0xba/0x1c6
>   [<ffffffff81b14c7e>] ? printk_all_partitions+0x259/0x26xb
>   [<ffffffff810566bb>] __stack_chk_fail+0x1b/0x20
>   [<ffffffff81b15c7e>] printk_all_paritions+0x259/0x26xb
>   [<ffffffff81aedfe0>] mount_block_root+0x1bc/0x27f
>   [<ffffffff81aee0fa>] mount_root+0x57/0x5b
>   [<ffffffff81aee23b>] prepare_namespace+0x13d/0x176
>   [<ffffffff8107eec0>] ? release_tgcred.isra.4+0x330/0x30
>   [<ffffffff81aedd60>] kernel_init+0x155/0x15a
>   [<ffffffff81087b97>] ? schedule_tail+0x27/0xb0
>   [<ffffffff815f4d24>] kernel_thread_helper+0x5/0x10
>   [<ffffffff81aedc0b>] ? start_kernel+0x3c5/0x3c5
>   [<ffffffff815f4d20>] ? gs_change+0x13/0x13
> 
> Increase the buffer size, remove the dangerous part_unpack_uuid() and
> use snprintf() directly from printk_all_partitions().

Ooops, thanks Tejun, applied for current branch.

-- 
Jens Axboe

