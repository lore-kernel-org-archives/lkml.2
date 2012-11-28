Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab2K1FPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 00:15:11 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63675 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab2K1FPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 00:15:08 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-3a-50b59dd9708a
Date: Wed, 28 Nov 2012 14:15:05 +0900
From: Minchan Kim <minchan@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>, Tomas M <tomas@slax.org>,
        Mihail Kasadjikov <hamer.mk@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] zram: Prevent use of unmapped buffer
Message-ID: <20121128051505.GD23136@blaptop>
References: <1354001167-24878-1-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354001167-24878-1-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

On Mon, Nov 26, 2012 at 11:26:07PM -0800, Nitin Gupta wrote:
> The commit c8f2f0db1 ("zram: Fix handling of incompressible pages")
> introduced a bug which caused a kunmap()'ed buffer to be used in case

I got confused by the descripton. :(
The descripton is not right.
The problem is to access freed memory, not accessing to kunmaped buffer.

partial I/O write.

1. uncmem = kmalloc
2. zram_decompress_page(uncmem)
3. memcpy(uncmem, user_mem)
4. lzo1x_1_compress(uncmem)
5. kfree(uncmem)
6. src = uncmem
7. memcpy(cmem, src, clen) <----- HIT

> of partial writes where the data was found to be incompressible.
> 
> This fixes bug 50081:
> https://bugzilla.kernel.org/show_bug.cgi?id=50081
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> Reported-by: Mihail Kasadjikov <hamer.mk@gmail.com>
> Reported-by: Tomas M <tomas@slax.org>

Good catch! Shame on me. I should have reivewed more carefully. :(
Please resend it with revised descrption and title.
I will rebase mh patchset just sent on top of this bug fix patch.

P.S) Sigh, Now code isn't clean due to partial read/write path handling.
     IMHO, sooner or later, we need refactoring.

-- 
Kind regards,
Minchan Kim
