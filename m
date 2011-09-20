Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1ITWrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 18:47:00 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:47057 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752190Ab1ITWq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 18:46:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAOAWeU55LAXJ/2dsb2JhbABCp2F5gVMBAQQBOhwjBQsIAw4KLhQlAyETFIdjoDuSbQ6GbwScHYhv
Date: Wed, 21 Sep 2011 08:46:55 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, sunil.mushran@oracle.com
Subject: Re: [PATCH] fs: add FS_IOC_UNRESVSP/FS_IOC_UNRESVSP64 ioctls
Message-ID: <20110920224655.GJ15688@dastard>
References: <1316528400-1797-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316528400-1797-1-git-send-email-dmonakhov@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 06:20:00PM +0400, Dmitry Monakhov wrote:
> Add ioctl interface for FALLOC_FL_PUNCH_HOLE. Ioctls are synonyms of
> XFS_IOC_UNRESVSP ioctls. Yes probably one can say than we already have
> a syscall intercase for fallocate, and in general this is right but:
>  - We already have FS_IOC_RESVSP (synonym of XFS_IOC_RESVSP)
>    and it heavily used. So actually this ioctl is not a
>    brand new one. It just makes RSV/URSV interface complete.

Those exist because filesystems copied them from XFS before
fallocate() was implemented. They are considered "legacy" interfaces
and are only kept for compatibility with old applications that were
using the XFS interfaces before fallocate came along.

>  - There are miliones lines of userspace code written
>    that can be reused for generic linux filesystems without
>    modification. SGI has open sourced many good stuff which are
>    under rapid development by linux community. For example
>    kernel.org/scm/fs/xfs/xfstests-dev.git  currently is one of
>    most used fs-regression testing suite.

Yes, but as it xfstests is currently maintained, the correct thing
to do is to extend it to use fallocate() interfaces so they get
tested. We've already done this for tools the test suite uses like
fsx, and there are new fallocate based hole punching tests that
have been added recently.

IMO, no new functionality should use [X]FS_IOC_*RESVSP ioctl
interfaces, and code that currently uses them should be ported to
use fallocate.

>    In other words i've added only 30lines of code, and get great
>    many good tools working for me, IMHO it is good deal.

Such as? I can't think of many tools in the linux ecosystem other
than XFS specific utilities that actually support hole
punching through this interface.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
