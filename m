Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935729Ab0GSO67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 10:58:59 -0400
Received: from verein.lst.de ([213.95.11.210]:38921 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935221Ab0GSO66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 10:58:58 -0400
Date: Mon, 19 Jul 2010 16:58:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] [fs/sysv] V7: Add support for non-PDP11 v7 filesystems
Message-ID: <20100719145851.GD25279@lst.de>
References: <1279559802-19154-1-git-send-email-lkundrak@v3.sk> <1279559802-19154-2-git-send-email-lkundrak@v3.sk> <1279559802-19154-3-git-send-email-lkundrak@v3.sk> <1279559802-19154-4-git-send-email-lkundrak@v3.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279559802-19154-4-git-send-email-lkundrak@v3.sk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 07:16:42PM +0200, Lubomir Rintel wrote:
> A mount-time option was added that makes it possible to override the
> endianness and an attempt is made to autodetect it (which seems easy,
> given the disk addresses are 3-byte.
> 
> No attempt is made to detect big-endian filesystems -- were there any?
> Tested with PDP-11 v7 filesystems and PC-IX maintenance floppy.

Do you actually need the mount option?  We get away just fine with
it for sysv filesystems.  And if not I'd be consistent and accept the
options for both sysv and v7 filesystems.

> +	/* plausibility check on root inode: it is a directory,
> +	   with a nonzero size that is a multiple of 16 */
> +	if ((bh2 = sb_bread(sb, 2)) == NULL) {
> +		return 0;
> +	}

A little style nitpick, this should be:

	bh2 = sb_bread(sb, 2);
	if (!bh)
		return 0;

