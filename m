Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab2JWAH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 20:07:59 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:2152 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932366Ab2JWAH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 20:07:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtwMAOfehVB5LNyp/2dsb2JhbABEhSu2IYVygQmCIAEBBTocIxAIAxguFCUDIROIA6t7kFIUi0SGbwOVcIlChniDAw
Date: Tue, 23 Oct 2012 11:07:33 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH v3 00/22] loop: Issue O_DIRECT aio using bio_vec
Message-ID: <20121023000733.GG4291@dastard>
References: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 10:15:00AM -0500, Dave Kleikamp wrote:
> This is the current version of the patchset I presented at the LSF-MM
> Summit in San Francisco in April. I apologize for letting it go so
> long before re-submitting.
> 
> This patchset was begun by Zach Brown and was originally submitted for
> review in October, 2009. Feedback was positive, and I have picked up
> where he left off, porting his patches to the latest mainline kernel
> and adding support more file systems.
> 
> This patch series adds a kernel interface to fs/aio.c so that kernel code can
> issue concurrent asynchronous IO to file systems.  It adds an aio command and
> file system methods which specify io memory with pages instead of userspace
> addresses.
> 
> This series was written to reduce the current overhead loop imposes by
> performing synchronus buffered file system IO from a kernel thread.  These
> patches turn loop into a light weight layer that translates bios into iocbs.

I note that there is no support for XFS in this patch set. Is there
a particular problem that prevents XFS from being converted, or it
just hasn't been done?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
