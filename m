Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0LJWsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 17:48:37 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:32645 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab0LJWsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 17:48:35 -0500
From: Lasse Collin <lasse.collin@tukaani.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH 1/2] Squashfs: add XZ compression support
Date: Sat, 11 Dec 2010 00:49:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-ARCH; KDE/4.5.4; x86_64; ; )
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Linux Embedded Maillist <linux-embedded@vger.kernel.org>
References: <4D00726D.3080503@lougher.demon.co.uk>
In-Reply-To: <4D00726D.3080503@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012110049.18135.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-09 Phillip Lougher wrote:
> +	stream->state = xz_dec_init(XZ_PREALLOC, block_size);

This sets the preallocated LZMA2 dictionary size to Squashfs block size, 
which allows the best compression ratio for the given block size (bigger 
values would be waste of memory). XZ decompressor needs about 30 KiB of 
memory plus the dictionary. So with 1 MiB Squashfs block size a little 
over 1 MiB of memory is needed by the XZ decompressor.

Would it be useful to support smaller dictionaries without reducing the 
Squashfs block size? It would save RAM while increasing the Squashfs 
image size less than if also the block size was reduced. Reasonable 
dictionary sizes could be e.g. 75 %, 50 %, or 25 % of the Squashfs block 
size. The size increase of the Squashfs image will vary a lot depending 
on the files in it, but e.g. dict_size = block_size / 2 won't 
necessarily increase the image size more than 1 %.

I don't know if this kind of RAM savings matter on embedded systems. I 
hope someone else can comment. My point in this email is only to let 
others know that reducing the RAM usage is possible without reducing the 
Squashfs block size.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
