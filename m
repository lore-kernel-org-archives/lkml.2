Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544Ab2AIXDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 18:03:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50207 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933478Ab2AIXDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 18:03:18 -0500
Date: Mon, 9 Jan 2012 23:03:16 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block_dev: Suppress bdev_cache_init() kmemleak warninig
Message-ID: <20120109230316.GZ23916@ZenIV.linux.org.uk>
References: <20120109224436.GA3429@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109224436.GA3429@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 01:44:36AM +0300, Sergey Senozhatsky wrote:

> due to attempt to mark pointer to `struct vfsmount' as a gray object, which
> is embedded into `struct mount' returned from alloc_vfsmnt(). Pass actual
> allocated `struct mount' pointer to kmemleak_not_leak() instead.

*snort*

how about turning bd_mnt into a static instead and to hell with messing with
annotations?  It's not like one word of .bss was worth those convolutions...
