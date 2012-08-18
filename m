Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab2HRNZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 09:25:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56383 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab2HRNZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 09:25:31 -0400
Date: Sat, 18 Aug 2012 14:25:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 0/4] fat: fix ESTALE errors
Message-ID: <20120818132524.GW23464@ZenIV.linux.org.uk>
References: <1345282899-7534-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345282899-7534-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 05:41:39AM -0400, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This patch-set eliminates the client side ESTALE errors when
> a FAT partition exported over NFS has its dentries evicted 
> from the cache.
> 
> One of the reasons for this error is lack of permanent inode 
> numbers on FAT which makes it difficult to construct persistent 
> file handles.This can be overcome by using the on-disk location
> of the directory entries (i_pos) as the inode number.

The hell it can.  You've just made them unstable on rename(2).
