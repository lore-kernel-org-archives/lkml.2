Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab2BWVtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:49:42 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40082 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab2BWVtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:49:41 -0500
Date: Thu, 23 Feb 2012 22:49:37 +0100
From: Johann Lombardi <johann@whamcloud.com>
To: santoshprasadnayak@gmail.com
Cc: tytso@mit.edu, adilger@dilger.ca, andrew_perepechko@xyratex.com,
        nikitas_angelinas@xyratex.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ext4: MMP: Fix endianness bug.
Message-ID: <20120223214937.GC2636@granier.hd.free.fr>
Mail-Followup-To: Johann Lombardi <johann@whamcloud.com>,
	santoshprasadnayak@gmail.com, tytso@mit.edu, adilger@dilger.ca,
	andrew_perepechko@xyratex.com, nikitas_angelinas@xyratex.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <4f468ef2.4105440a.56cc.ffffa1d7@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f468ef2.4105440a.56cc.ffffa1d7@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 12:39:05AM +0530, santoshprasadnayak@gmail.com wrote:
> @@ -257,8 +257,8 @@ int ext4_multi_mount_protect(struct super_block *sb,
>  	 * If check_interval in MMP block is larger, use that instead of
>  	 * update_interval from the superblock.
>  	 */
> -	if (mmp->mmp_check_interval > mmp_check_interval)
> -		mmp_check_interval = mmp->mmp_check_interval;
> +	if (le16_to_cpu(mmp->mmp_check_interval) > mmp_check_interval)
> +		mmp_check_interval = le16_to_cpu(mmp->mmp_check_interval);

Looks good to me.
Reviewed-by: Johann Lombardi <johann@whamcloud.com>

Johann
