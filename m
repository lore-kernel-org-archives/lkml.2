Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab2JCVSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:18:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab2JCVSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:18:05 -0400
Date: Wed, 3 Oct 2012 14:18:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ard Biesheuvel <ard.biesheuvel@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Updated: [PATCH] hardening: add PROT_FINAL prot flag to
 mmap/mprotect
Message-Id: <20121003141804.f9896690.akpm@linux-foundation.org>
In-Reply-To: <506C4F29.4090303@gmail.com>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>
	<20120820180037.GV4232@outflux.net>
	<CAKFga-dDRyRwxUu4Sv7QLcoyY5T3xxhw48LP2goWs=avGW0d_A@mail.gmail.com>
	<CAGXu5jJCqABZcMHuQNAaAcUKCEsSqOTn5=DHdwFdJ70zVLsmSQ@mail.gmail.com>
	<CAKFga-fB2JSAscSVi+YUOnFS4Lq4yzH5MHRwxDQBQYZfKAgB6A@mail.gmail.com>
	<CAGXu5jLj6qm+Rv3v2pmJqfEmhZBkKJsMUe0aRqxSa=s=w4wbDw@mail.gmail.com>
	<20121002153841.a03ad73b.akpm@linux-foundation.org>
	<alpine.LSU.2.00.1210021733580.1343@eggly.anvils>
	<506C4F29.4090303@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Oct 2012 16:43:53 +0200
Ard Biesheuvel <ard.biesheuvel@gmail.com> wrote:

> This patch adds support for the PROT_FINAL flag to
> the mmap() and mprotect() syscalls.
> 
> The PROT_FINAL flag indicates that the requested set
> of protection bits should be final, i.e., it shall
> not be allowed for a subsequent mprotect call to
> set protection bits that were not set already.
> 
> This is mainly intended for the dynamic linker,
> which sets up the address space on behalf of
> dynamic binaries. By using this flag, it can
> prevent exploited code from remapping read-only
> executable code or data sections read-write.

Again: has this proposal been reviewed by the glibc maintainers?  If
so, what was their position on it?

Also, you earlier stated that "It's a more direct version of PaX's
"MPROTECT" feature[1]".  This is useful information.  Please update the
changelog to describe that PaX feature and to describe the difference
between the two, and the reasons for that difference.

It sounds as though the PaX developers could provide useful review
input on this proposal.  Do they know about it?  If so, what is their
position?

Thanks.
