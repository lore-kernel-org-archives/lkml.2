Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0JGXZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 19:25:04 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:41242 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752534Ab0JGXZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 19:25:03 -0400
Date: Fri, 8 Oct 2010 10:24:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andreas Wiese <aw-lkml@meterriblecrew.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ciaran McCreesh <ciaran.mccreesh@googlemail.com>, xfs@oss.sgi.com
Subject: Re: fallocate() on XFS clobbers S*ID-bits
Message-ID: <20101007232451.GO4681@dastard>
References: <20101007183418.GC5621@incendiary.meterriblecrew.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101007183418.GC5621@incendiary.meterriblecrew.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ added xfs list on cc ]

On Thu, Oct 07, 2010 at 08:34:19PM +0200, Andreas Wiese wrote:
> Hello.
> 
> I (with support from Cc'ed Ciaran) just noticed some odd behaviour with
> fallocate() on XFS.  After open()ing some file and setting it S*ID via
> fchmod(), S*ID bits vanish after calling fallocate() — as supposed to
> for non-root users, but it also happens for root.
> 
> Is this intended behaviour or did we spot a bug here?
> 
> At least on ext2 it works as expected, thus I guess it's the latter one.

ext2 does not support the fallocate syscall. How does ext4 behave?

> I'm running v2.6.35.7 vanilla-kernel, but diffing fs/xfs to master
> doesn't seem to address this issue.

XFS has always cleared SUID/SGID bits when doing preallocation (via
XFS_IOC_RESVSP). Given that that XFS ioctl formed the model for
fallocate, I'd argue that the XFS behaviour is the on that should be
followed.

It'd be a bit silly for two different preallocation interfaces to
have different behaviour w.r.t. SUID bits, but it's not clear to me
which behaviour is correct. I'm happy to defer to whoever can say
what the behaviour is supposed to be here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
