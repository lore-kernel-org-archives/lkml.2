Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769Ab2JWWrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:47:11 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:33181 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754499Ab2JWWrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:47:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AosYAFkdh1B5LNyp/2dsb2JhbABEhSu2UYRyAoEOgQmCHgEBBAE6HCMFCwgDDgouFCUDIROHfgW7HBSLTCCBYoRcA5VxiUKGeIMDgUcf
Date: Wed, 24 Oct 2012 09:47:06 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ying Zhu <casualfisher@gmail.com>
Cc: akpm@linux-foundation.org, fengguang.wu@intel.com,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: readahead: remove redundant ra_pages in file_ra_state
Message-ID: <20121023224706.GR4291@dastard>
References: <1350996411-5425-1-git-send-email-casualfisher@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350996411-5425-1-git-send-email-casualfisher@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 08:46:51PM +0800, Ying Zhu wrote:
> Hi,
>   Recently we ran into the bug that an opened file's ra_pages does not
> synchronize with it's backing device's when the latter is changed
> with blockdev --setra, the application needs to reopen the file
> to know the change,

or simply call fadvise(fd, POSIX_FADV_NORMAL) to reset the readhead
window to the (new) bdi default.

> which is inappropriate under our circumstances.

Which are? We don't know your circumstances, so you need to tell us
why you need this and why existing methods of handling such changes
are insufficient...

Optimal readahead windows tend to be a physical property of the
storage and that does not tend to change dynamically. Hence block
device readahead should only need to be set up once, and generally
that can be done before the filesystem is mounted and files are
opened (e.g. via udev rules). Hence you need to explain why you need
to change the default block device readahead on the fly, and why
fadvise(POSIX_FADV_NORMAL) is "inappropriate" to set readahead
windows to the new defaults.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
