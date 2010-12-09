Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab0LIGGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 01:06:01 -0500
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:38153 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753432Ab0LIGF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 01:05:59 -0500
Message-ID: <4D0071C3.3070500@lougher.demon.co.uk>
Date: Thu, 09 Dec 2010 06:05:55 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Linux Embedded Maillist <linux-embedded@vger.kernel.org>
CC: Lasse Collin <lasse.collin@tukaani.org>
Subject: [PATCH 0/2] Squashfs: add XZ compression support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following the recent posting of patches by Lasse Collin to add XZ (LZMA2)
support to the kernel (http://thread.gmane.org/gmane.linux.kernel/1071297),
I have added support for this to Squashfs.

Advantages of Squashfs XZ over the Squashfs LZMA implementation:

- Significantly better decompressor API supporting multi-call decoding,
   which requires less buffer overhead.
- Greater data robustness due to XZ's CRC32 check.
- BCJ filters which can produce smaller Squashfs images.

The following two patches add Squashfs kernel support.  A git tree with
these patches including Lasse Collin's patches is available here:

http://git.kernel.org/?p=linux/kernel/git/pkl/squashfs-xz.git;a=summary

XZ support has (obviously) also been added to the squashfs tools (Mksquashfs
& Unsquashfs).  These changes are available from the Squashfs CVS repository
(http://sourceforge.net/projects/squashfs/develop).

To build the Squashfs tools, edit the Makefile to enable XZ support
(by default it is disabled).

XZ compression can be specified by using the -comp option, e.g.
% mksquashfs xxx img.sqsh -comp xz

XZ BCJ filters (which can improve the compression of executable code
on certain architectures) are supported by using the -Xbcj option, e.g.

% mksquashfs xxx img.sqsh -comp xz -Xbcj x86

will compress blocks using XZ with no filter, and then XZ with the x86
filter in turn, and choose the best compression.

Multiple filters can be specified which is useful in cases where the source
file system has executable code from a mixture of different architectures,
and again each filter will be tried for each block and the best compression
used, e.g.

% mksquashfs xxx img.sqsh -comp xz -Xbcj x86,arm

will try both the x86 and arm BCJ filters.

Phillip

