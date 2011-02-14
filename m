Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1BNXj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:39:59 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39736 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab1BNXjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:39:55 -0500
MIME-Version: 1.0
In-Reply-To: <1297691128.1857.4.camel@dan>
References: <1297347904.13370.9.camel@dan>
	<20110214114629.GA13052@dastard>
	<1297691128.1857.4.camel@dan>
Date: Tue, 15 Feb 2011 07:39:53 +0800
Message-ID: <AANLkTim7zYvwFyVTEMFDyGBR8d0Ka9ruK+R_+s-Rf5Fa@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1
From: Eugene Teo <eugeneteo@kernel.sg>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Dave Chinner <david@fromorbit.com>, aelder@sgi.com,
        xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, security@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 9:45 PM, Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
> xfs_fs_geometry() with a version number of 3.  This code path does not
> fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
> the leaking of four bytes of uninitialized stack data to potentially
> unprivileged callers.
>
> v2 switches to memset() to avoid future issues if structure members
> change, on suggestion of Dave Chinner.
>
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>

Reviewed-by: Eugene Teo <eugeneteo@kernel.org>

> ---
>  fs/xfs/xfs_fsops.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index cec89dd..85668ef 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -53,6 +53,9 @@ xfs_fs_geometry(
>        xfs_fsop_geom_t         *geo,
>        int                     new_version)
>  {
> +
> +       memset(geo, 0, sizeof(*geo));
> +
>        geo->blocksize = mp->m_sb.sb_blocksize;
>        geo->rtextsize = mp->m_sb.sb_rextsize;
>        geo->agblocks = mp->m_sb.sb_agblocks;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
