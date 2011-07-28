Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1G1SVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 14:21:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47731 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234Ab1G1SVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 14:21:31 -0400
Date: Thu, 28 Jul 2011 19:21:29 +0100
From: Will Deacon <will.deacon@arm.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: sys_readlink() with empty filename
Message-ID: <20110728182129.GG32284@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

In commit 65cfc672 ("readlinkat(), fchownat() and fstatat() with empty
relative pathnames") you changed the behaviour of the readlink syscall so
that LOOKUP_EMPTY is passed in the lookup flags. This causes the syscall to
return -EINVAL rather than -ENOENT if the filename is empty.

Looking at the man page for readlink, it's not obvious to me what the
correct behaviour should be. However, this change has also been noticed by
the gnulib guys because it causes the coreutils tests to fail:

http://comments.gmane.org/gmane.comp.lib.gnulib.bugs/25791

I noticed it as a regression in LTP.

So is this behaviour unspecified by POSIX and are the tests all broken or
should it be fixed in the kernel / C library?

Cheers,

Will
