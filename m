Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967919Ab2ERJd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:33:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57210 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967457Ab2ERJdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:33:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Matthew Wilcox <willy@linux.intel.com>, Carsten Otte <cotte@de.ibm.com>
Subject: Re: NVM Mapping API
Date: Fri, 18 May 2012 09:33:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120515133450.GD22985@linux.intel.com>
In-Reply-To: <20120515133450.GD22985@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205180933.49516.arnd@arndb.de>
X-Provags-ID: V02:K0:krBLVWlLk+7/+IczaK/fhtRPZ4PixxhsWvKkjH1a3Dd
 icNnvsRQwJYaDr9QluJNIIqBNWf1hvWs8zVe8df4HTGX2XsW46
 Gj+Jh/4h2AaGf18x1ivo/RctDuCLUA7KgOz/BqBp1GJMKFbQRy
 LexfDCzPDkKyLh1RTFtnKcZJG1CR9lZvNhJ1cAb24b8oqkO9fs
 XLsfui/yD47dkZj2xa2JdUu5HWYgcUgPLddJdj7IoB6heedC0V
 xtTImEtGTzlxW0/mlrmOieu4xIP4v9Zl1lrzuK0g8L5cjOfNeX
 2WkmzWnJ5WJiIGqrXE93DJa/jtR6dWpuGu1wwtGd1OZsj7WukG
 gG/OwXInM2Qiq5GvGjss=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2012, Matthew Wilcox wrote:
> 
> There are a number of interesting non-volatile memory (NVM) technologies
> being developed.  Some of them promise DRAM-comparable latencies and
> bandwidths.  At Intel, we've been thinking about various ways to present
> those to software.  This is a first draft of an API that supports the
> operations we see as necessary.  Patches can follow easily enough once
> we've settled on an API.
> 
> We think the appropriate way to present directly addressable NVM to
> in-kernel users is through a filesystem.  Different technologies may want
> to use different filesystems, or maybe some forms of directly addressable
> NVM will want to use the same filesystem as each other.

ext2 actually supports some of this already with mm/filemap_xip.c, Carsten
Otte introduced it initially to support drivers/s390/block/dcssblk.c with
execute-in-place, so you don't have to copy around the data when your
block device is mapped into the physical address space already.

I guess this could be implemented in modern file systems (ext4, btrfs)
as well, or you could have a new simple fs on top of the same base API.
(ext2+xip was originally a new file system but then merged into ext2).

Also note that you could easily implement non-volatile memory in other
virtual machines doing the same thing that dcssblk does: E.g. in KVM
you would only need to map a host file into the guess address space
and let the guest take advantage of a similar feature set that you
get from the new memory technologies in real hardware.

	Arnd
