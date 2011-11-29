Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1K2AQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 19:16:35 -0500
Received: from natasha.panasas.com ([67.152.220.90]:58594 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab1K2AQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 19:16:32 -0500
Message-ID: <4ED422CC.60706@panasas.com>
Date: Mon, 28 Nov 2011 16:09:48 -0800
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Benny Halevy <bhalevy@tonian.com>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: linux-next: Tree for Nov 24 (fs/pnfs vs. exofs)
References: <20111124174358.d88f11c0ff700e5e6b3bf73b@canb.auug.org.au> <4ECE91F3.9010007@xenotime.net>
In-Reply-To: <4ECE91F3.9010007@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 10:50 AM, Randy Dunlap wrote:
> On 11/23/2011 10:43 PM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20111123:
> 
> 
> When CONFIG_EXOFS is not enabled:
> 
> fs/built-in.o: In function `objio_alloc_io_state':
> objio_osd.c:(.text+0xcb525): undefined reference to `ore_get_rw_state'
> fs/built-in.o: In function `_write_done':
> objio_osd.c:(.text+0xcb58d): undefined reference to `ore_check_io'
> fs/built-in.o: In function `_read_done':
> objio_osd.c:(.text+0xcb5bf): undefined reference to `ore_check_io'
> fs/built-in.o: In function `objio_alloc_lseg':
> (.text+0xcb9a4): undefined reference to `ore_verify_layout'
> fs/built-in.o: In function `objio_free_result':
> (.text+0xcbb0e): undefined reference to `ore_put_io_state'
> fs/built-in.o: In function `objio_read_pagelist':
> (.text+0xcbc9b): undefined reference to `ore_read'
> fs/built-in.o: In function `objio_write_pagelist':
> (.text+0xcbd4e): undefined reference to `ore_write'
> 
> 
> Full randconfig file is attached.
> 

Thanks Randy. I completely missed that one.

The missing enablement is not CONFIG_EXOFS (that, I tested). It is the
CONFIG_MISC_FILESYSTEMS. Because CONFIG_MISC_FILESYSTEMS is not set then
exofs/Kconfig is not examined and it cannot do it's magic in selecting
everything.

I'm posting a patch as a separate mail reply.

What I did was revert to the old way of forcing all users of the ORE
to select everything that it requires. Instead of the elegant way it
was. The other choice is, of course, to move ore to the lib/ directory
but that one I fear even more. So here ...

Thanks
Boaz
