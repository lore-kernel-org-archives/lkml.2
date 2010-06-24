Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0FXNPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:15:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393Ab0FXNPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:15:00 -0400
Date: Thu, 24 Jun 2010 23:14:55 +1000
From: Nick Piggin <npiggin@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [rfc] new stat*fs-like syscall?
Message-ID: <20100624131455.GA10441@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has come up a few times in the past, and I'd like to try to get
an agreement on it. statvfs(2) importantly contains f_flag (mount
flags), and is encouraged to use rather than statfs(2). The kernel
provides a statfs syscall only.

This means glibc has to provide f_flag support by parsing /proc/mounts
and stat(2)ing mount points. This is really slow, and /proc/mounts is
hard for the kernel to provide. It's actually the last scalability
bottleneck in the core vfs for dbench (samba) after my patches.

Not only that, but it's racy.

Other than types, other differences are:
- statvfs(2) has is f_frsize, which seems fairly useless.
- statvfs(2) has f_favail.
- statfs(2) f_bsize is optimal transfer block, statvfs(2) f_bsize is fs
  block size. The latter could be useful for disk space algorithms.
  Both can be ill defned.
- statvfs(2) lacks f_type.

Is there anything more we should add here? Samba wants a capabilities
field, with things like sparse files, quotas, compression, encryption,
case preserving/sensitive.

Any thoughts?

Thanks,
Nick

