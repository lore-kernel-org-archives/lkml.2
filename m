Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab1JSOWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:22:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42783 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286Ab1JSOWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:22:50 -0400
Subject: Re: [PATCH v2 1/2] jffs2: implement mount option parsing and
 compression overriding
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andres Salomon <dilinger@queued.net>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Wed, 19 Oct 2011 17:22:28 +0300
In-Reply-To: <20111016181516.489cbbf9@queued.net>
References: <20111016181516.489cbbf9@queued.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1319034155.25389.81.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-16 at 18:15 -0700, Andres Salomon wrote:
> Currently jffs2 has compile-time constants (and .config options)
> controlling whether or not the various compression/decompression
> drivers are built in and enabled.  This is fine for embedded
> systems, but it clashes with distribution kernels.  Distro kernels
> tend to turn on everything; this causes OpenFirmware to fall
> over, as it understands ZLIB-compressed inodes.  Booting a kernel
> that has LZO compression enabled, writing to the boot partition,
> and then rebooting causes OFW to fail to read the kernel from
> the filesystem.  This is because LZO compression has priority
> when writing new data to jffs2, if LZO is enabled.
> 
> This patch adds mount option parsing, and a single supported
> option ("compr=none").  This adds the flexibility of being
> able to specify which compressor overrides on a per-superblock
> basis.  For now, we can simply disable compression;
> additional flexibility coming soon.

Pushed both to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

