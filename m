Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab1HBPrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 11:47:53 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59874 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753318Ab1HBPrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 11:47:48 -0400
Date: Tue, 2 Aug 2011 16:47:47 +0100
From: Will Deacon <will.deacon@arm.com>
To: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sys_readlink() with empty filename
Message-ID: <20110802154746.GC29456@e102144-lin.cambridge.arm.com>
References: <20110728182129.GG32284@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110728182129.GG32284@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 07:21:29PM +0100, Will Deacon wrote:
> Hi Al,
> 
> In commit 65cfc672 ("readlinkat(), fchownat() and fstatat() with empty
> relative pathnames") you changed the behaviour of the readlink syscall so
> that LOOKUP_EMPTY is passed in the lookup flags. This causes the syscall to
> return -EINVAL rather than -ENOENT if the filename is empty.
> 
> Looking at the man page for readlink, it's not obvious to me what the
> correct behaviour should be. However, this change has also been noticed by
> the gnulib guys because it causes the coreutils tests to fail:
> 
> http://comments.gmane.org/gmane.comp.lib.gnulib.bugs/25791
> 
> I noticed it as a regression in LTP.
> 
> So is this behaviour unspecified by POSIX and are the tests all broken or
> should it be fixed in the kernel / C library?

Any comments on this? I'm reluctant to start changing tests if this is just
an oversight in the kernel.

Thanks,

Will
