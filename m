Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1BIPwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 10:52:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab1BIPwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 10:52:05 -0500
Date: Wed, 9 Feb 2011 10:51:33 -0500
From: Josef Bacik <josef@redhat.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: chris.mason@oracle.com, security@kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] btrfs: prevent heap corruption in
	btrfs_ioctl_space_info()
Message-ID: <20110209155130.GA2564@localhost.localdomain>
References: <1297260766.2327.40.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297260766.2327.40.camel@dan>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 09:12:46AM -0500, Dan Rosenberg wrote:
> Commit bf5fc093c5b625e4259203f1cee7ca73488a5620 refactored
> btrfs_ioctl_space_info() and introduced several security issues.
> 
> space_args.space_slots is an unsigned 64-bit type controlled by a
> possibly unprivileged caller.  The comparison as a signed int type
> allows providing values that are treated as negative and cause the
> subsequent allocation size calculation to wrap, or be truncated to 0.
> By providing a size that's truncated to 0, kmalloc() will return
> ZERO_SIZE_PTR.  It's also possible to provide a value smaller than the
> slot count.  The subsequent loop ignores the allocation size when
> copying data in, resulting in a heap overflow or write to ZERO_SIZE_PTR.
> 
> The fix changes the slot count type and comparison typecast to u64,
> which prevents truncation or signedness errors, and also ensures that we
> don't copy more data than we've allocated in the subsequent loop.  Note
> that zero-size allocations are no longer possible since there is already
> an explicit check for space_args.space_slots being 0 and truncation of
> this value is no longer an issue.
> 
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
