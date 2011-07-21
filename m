Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab1GUVzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:55:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751562Ab1GUVza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:55:30 -0400
Date: Thu, 21 Jul 2011 14:54:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-man@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Cross Memory Attach v3
Message-Id: <20110721145433.a77818b2.akpm@linux-foundation.org>
In-Reply-To: <20110719003537.16b189ae@lilo>
References: <20110719003537.16b189ae@lilo>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jul 2011 00:35:37 +0930
Christopher Yeoh <cyeoh@au1.ibm.com> wrote:

> Hi Andrew,
> 
> Resending with CC's as you requested. Have added information about a man
> page and what is required for arches other than x86 and powerpc which
> have already been done.
> 
> Just as a reminder of what has happened so far, repeating some content
> from previous emails about it:
> 
> The basic idea behind cross memory attach is to allow MPI programs doing
> intra-node communication to do a single copy of the message rather than
> a double copy of the message via shared memory.
> 
> The following patch attempts to achieve this by allowing a
> destination process, given an address and size from a source process, to
> copy memory directly from the source process into its own address space
> via a system call. There is also a symmetrical ability to copy from 
> the current process's address space into a destination process's
> address space.
>
> ...
>
>  arch/powerpc/include/asm/systbl.h  |    2 
>  arch/powerpc/include/asm/unistd.h  |    4 
>  arch/x86/include/asm/unistd_32.h   |    4 
>  arch/x86/kernel/syscall_table_32.S |    2 
>  fs/aio.c                           |    4 
>  fs/compat.c                        |    7 
>  fs/read_write.c                    |    8 
>  include/linux/compat.h             |    3 
>  include/linux/fs.h                 |    7 
>  include/linux/syscalls.h           |   13 +
>  mm/Makefile                        |    3 
>  mm/process_vm_access.c             |  446 +++++++++++++++++++++++++++++++++++++
>  security/keys/compat.c             |    2 
>  security/keys/keyctl.c             |    2 
>  14 files changed, 490 insertions(+), 17 deletions(-)

Confused.  Why no arch/x86/include/asm/unistd_64.h wire-up?
