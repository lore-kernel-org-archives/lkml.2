Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0HISzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 14:55:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60757 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab0HISzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 14:55:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH] vfs: introduce FS_IOC_SYNCFS to sync a single super
Date: Mon, 9 Aug 2010 20:55:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <Pine.LNX.4.64.1008090711040.17515@cobra.newdream.net>
In-Reply-To: <Pine.LNX.4.64.1008090711040.17515@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008092055.07248.arnd@arndb.de>
X-Provags-ID: V02:K0:+k6DdlhqaQs9tkTjLgQ6UWhFVtGZ36+yZ5c8PAYhN+G
 gUjlaKhXPDfYg4bkEPYBYIWeE4uoDyFizHMlBjwah4dv42z6G+
 Ih+SMFn5i9b5UULRllsv6d6fJgQS1mx2u5z7Osl7wd6w8O9ntJ
 XfFn1isjk2ZWoLtEQgz50mDVYXG6YOrrdldjc0KbcQ/YJhANq8
 iGSA+TZSqepIYUvzpp8xQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 August 2010, Sage Weil wrote:
> Currently the only way to sync a single super_block (and not all of them 
> via sync(2)) is via the BLKFLSBUF ioctl on the block device.  That also 
> invalidates the bdev mapping, which isn't usually desireable, and it 
> doesn't work for non-block file systems.  The ability to sync a single 
> mount can be useful for both applications and administrators (e.g., when 
> other mounts on the system are hung).

You need to add this to the compat_ioctl handling as well, otherwise
it won't work when you run a 32 bit process in a 64 bit kernel.

Adding it to the ioctl_pointer[] array is probably the easiest way.

	Arnd 
