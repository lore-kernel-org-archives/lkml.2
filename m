Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab1CMVDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 17:03:53 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20900 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab1CMVDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 17:03:50 -0400
Date: Sun, 13 Mar 2011 22:03:28 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-btrfs@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] BTRFS: Fix mem leak in btrfs_submit_direct()
In-Reply-To: <alpine.LNX.2.00.1103132145250.29706@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1103132202450.29706@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1103132145250.29706@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Mar 2011, Jesper Juhl wrote:

> When memory is low and the allocation for 'dip->csums' fail in 
> fs/btrfs/inode.c:btrfs_submit_direct() we make the situation worse by 
> leaking the memory allocated to 'dip'.
> This patch removes the leak by kfree()'ing 'dip' before jumping to the 
> 'free_ordered' label.
> 

Ignore this patch. I see now that Daniel J Blueman already submitted a fix 
for this issue. Sorry about the noise.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

