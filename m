Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2IKWsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:48:09 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:26769 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788Ab2IKWsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:48:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgwKAOC+T1B5LPyM/2dsb2JhbABFulADgQSBCIIgAQEFOhwjEAgDFQMuFA0YAzSHfgMODLJCDYlTFIoZYwllghmDHwOUCoFUiTSBYoUIgniBSA
Date: Wed, 12 Sep 2012 08:48:05 +1000
From: Dave Chinner <david@fromorbit.com>
To: raghu.prabhu13@gmail.com
Cc: xfs@oss.sgi.com, Raghavendra D Prabhu <rprabhu@wnohang.net>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] XFS: Print error when xfs_ialloc_ag_select fails to
 find continuous free space.
Message-ID: <20120911224805.GG11511@dastard>
References: <cover.1347396641.git.rprabhu@wnohang.net>
 <b4227a4a67fb7b50bcf83fa369ba8999d3409d64.1347396641.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4227a4a67fb7b50bcf83fa369ba8999d3409d64.1347396641.git.rprabhu@wnohang.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 03:43:23AM +0530, raghu.prabhu13@gmail.com wrote:
> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
> 
> When xfs_ialloc_ag_select fails to find any AG with continuous free blocks
> required for inode allocation, printk the error in ratelimited manner.
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> ---
>  fs/xfs/xfs_ialloc.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index 5aceb3f..e75a39d 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -539,8 +539,11 @@ nextag:
>  		if (agno >= agcount)
>  			agno = 0;
>  		if (agno == pagno) {
> -			if (flags == 0)
> +			if (flags == 0) {
> +				xfs_err_ratelimited(mp,
> +					"Out of continuous free blocks for inode allocation");

http://oss.sgi.com/archives/xfs/2012-06/msg00041.html

<quote>
Couple of things for all 3 patches. Firstly - 80 columns. We tend
to keep the pformat string on a single line so it is easy to grep
for like so:

				pr_err_once(mp,
		"Insufficient contiguous free space for inode allocation");
</quote>

So, you need to change the error message to the one suggested, and
follow 80-character width limits like the rest of the code.

Also, I think the error message is better at the caller site, not in
the function itself. i.e. if we get a NULLAGNUMBER returned, the
caller decided whether to emit an error message or not.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
