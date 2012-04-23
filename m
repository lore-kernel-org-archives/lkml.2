Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2DWWmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:42:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46237 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2DWWmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:42:17 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1331137504.git.jbaron@redhat.com>
References: <cover.1331137504.git.jbaron@redhat.com>
Date: Tue, 24 Apr 2012 10:42:16 +1200
X-Google-Sender-Auth: 9j63bBlZaSm9hmXJATEtq-KV2Xw
Message-ID: <CAHO5Pa0cyvD-zUh-RRyOwvu2FGQYOMn_thFQt3_64BDi-wB=GQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] core dump: re-purpose VM_ALWAYSDUMP to user
 controlled VM_DONTDUMP
From: Michael Kerrisk <mtk.manpages@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: mcgrathr@google.com, akpm@linux-foundation.org, avi@redhat.com,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason,

On Thu, Mar 8, 2012 at 6:00 AM, Jason Baron <jbaron@redhat.com> wrote:
> Hi,
>
> The motivation for this change was that I was looking at a way for a qemu-kvm
> process, to exclude the guest memory from its core dump, which can be quite
> large. There are already a number of filter flags in
> /proc/<pid>/coredump_filter, however, these allow one to specify 'types' of
> kernel memory, not specific address ranges (which is needed in this case).
>
> Since there are no more vma flags available, the first patch eliminates the
> need for the 'VM_ALWAYSDUMP' flag. The flag is used internally by the kernel to
> mark vdso and vsyscall pages. However, it is simple enough to check if a vma
> covers a vdso or vsyscall page without the need for this flag.
>
> The second patch then replaces the 'VM_ALWAYSDUMP' flag with a new
> 'VM_DONTDUMP' flag, which can be set by userspace using new madvise flags:
> 'MADV_DONTDUMP', and unset via 'MADV_DUMP'. The core dump filters continue to
> work the same as before unless 'MADV_DONTDUMP' is set on the region.
>
> The qemu code which implements this features is at:
> http://people.redhat.com/~jbaron/qemu-dump/qemu-dump.patch
>
> In my testing the qemu core dump shrunk from 383MB -> 13MB with this patch.
>
> I also believe that the 'MADV_DONTDUMP' flag might be useful for security
> sensitive apps, which might want to select which areas are dumped.

Since we have
MADV_DODUMP
MADV_DONTDUMP
MADV_NODUMP
heading for userspace in 3.4, would you be willing to write patches
for the madvise(2) man page to describe these flags?

See http://www.kernel.org/doc/man-pages/download.html for details on
accessing man-pages Git.

Cheers,

Michael

PS Please also CC linux-api@ when making API/ABI changes.


-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
