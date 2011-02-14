Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab1BNIls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 03:41:48 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37697 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1BNIlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 03:41:47 -0500
MIME-Version: 1.0
In-Reply-To: <1297347904.13370.9.camel@dan>
References: <1297347904.13370.9.camel@dan>
Date: Mon, 14 Feb 2011 16:41:46 +0800
X-Google-Sender-Auth: EpuL8YTBzPXlDK5ol7jWqSnBF34
Message-ID: <AANLkTi=BxmspGnK1FLwNswQP34kTU96Q0G2xBNoxypCh@mail.gmail.com>
Subject: Re: [Security] [PATCH] xfs: prevent leaking uninitialized stack
 memory in FSGEOMETRY_V1
From: Eugene Teo <eugeneteo@kernel.org>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: aelder@sgi.com, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        security@kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org,
        Eugene Teo <eugeneteo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 10:25 PM, Dan Rosenberg
<drosenberg@vsecurity.com> wrote:
> The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
> xfs_fs_geometry() with a version number of 3.  This code path does not
> fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
> the leaking of four bytes of uninitialized stack data to potentially
> unprivileged callers.  Since all other members are filled in all code
> paths and there are no padding bytes in this structure, it's safe to
> avoid an expensive memset() in favor of just clearing this one field.
>
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>

There are three callers to xfs_fs_geometry() with version number 3 and
4. I don't see any for version number 2, so this looks fine.

Reviewed-by: Eugene Teo <eugeneteo@kernel.org>

Thanks, Eugene
