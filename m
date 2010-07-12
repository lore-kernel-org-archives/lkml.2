Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab0GLTt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 15:49:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22933 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab0GLTtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 15:49:55 -0400
Date: Mon, 12 Jul 2010 12:47:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 12 (debugfs/sysfs/rcu)
Message-Id: <20100712124750.8ab5e870.randy.dunlap@oracle.com>
In-Reply-To: <20100712155109.d997bf1c.sfr@canb.auug.org.au>
References: <20100712155109.d997bf1c.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C3B71D9.0214:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 15:51:09 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100709:

Greg,
What is there about debugfs that requires sysfs?

(lib/Kconfig.debug:)

config DEBUG_FS
	bool "Debug Filesystem"
	depends on SYSFS

I ask because kconfig now (in linux-next) warns about kconfig dependency
problems, like this one:

warning: (TREE_RCU_TRACE || AMD_IOMMU_STATS && AMD_IOMMU || MTD_UBI_DEBUG && MTD && SYSFS && MTD_UBI || UBIFS_FS_DEBUG && MISC_FILESYSTEMS && UBIFS_FS || DEBUG_KMEMLEAK && DEBUG_KERNEL && EXPERIMENTAL && !MEMORY_HOTPLUG && (X86 || ARM || PPC || S390 || SPARC64 || SUPERH || MICROBLAZE) && SYSFS || TRACING || X86_PTDUMP && DEBUG_KERNEL || BLK_DEV_IO_TRACE && TRACING_SUPPORT && FTRACE && SYSFS && BLOCK) selects DEBUG_FS which has unmet direct dependencies (SYSFS)

because TREE_RCU_TRACE selects DEBUG_FS, even when SYSFS is not enabled.
I first made a patch to have TREE_RCU_TRACE depend on SYSFS, but then I just
removed the DEBUG_FS "depends on SYSFS" and the kernel builds fine,
hence the first question.

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
