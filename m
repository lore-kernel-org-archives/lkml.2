Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab2LPCPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 21:15:11 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:59274 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab2LPCPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 21:15:10 -0500
Date: Sun, 16 Dec 2012 02:15:08 +0000
From: Eric Wong <normalperson@yhbt.net>
To: xtu4 <xiaobing.tu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        linux-mm@kvack.org, di.zhang@intel.com
Subject: Re: resend--[PATCH]  improve read ahead in kernel
Message-ID: <20121216021508.GA3629@dcvr.yhbt.net>
References: <50C4B4E7.60601@intel.com>
 <50C6AB45.606@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C6AB45.606@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtu4 <xiaobing.tu@intel.com> wrote:
> resend it, due to format error
> 
> Subject: [PATCH] when system in low memory scenario, imaging there is a mp3
>  play, ora video play, we need to read mp3 or video file
>  from memory to page cache,but when system lack of memory,
>  page cache of mp3 or video file will be reclaimed.once read
>  in memory, then reclaimed, it will cause audio or video
>  glitch,and it will increase the io operation at the same
>  time.

To me, this basically describes how POSIX_FADV_NOREUSE should work.
I would like to have this ability via fadvise (and not CONFIG_).

Also, I think your patch has too many #ifdefs to be accepted.
