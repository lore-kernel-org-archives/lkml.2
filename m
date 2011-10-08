Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1JHVZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 17:25:22 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:54794 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab1JHVZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 17:25:19 -0400
Date: Sat, 8 Oct 2011 17:25:19 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Nikitas Angelinas <nikitasangelinas@gmail.com>
Cc: adilger.kernel@dilger.ca, adilger@whamcloud.com, johann@whamcloud.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        nikitas_angelinas@xyratex.com, andrew_perepechko@xyratex.com
Subject: Re: [PATCH 2/2] ext4: MMP: fix error message rate-limiting logic
 in kmmpd
Message-ID: <20111008212519.GO7948@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Nikitas Angelinas <nikitasangelinas@gmail.com>,
	adilger.kernel@dilger.ca, adilger@whamcloud.com,
	johann@whamcloud.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, nikitas_angelinas@xyratex.com,
	andrew_perepechko@xyratex.com
References: <1316737389-5522-1-git-send-email-nikitas_angelinas@xyratex.com>
 <1317339500-4341-1-git-send-email-nikitas_angelinas@xyratex.com>
 <1317339500-4341-3-git-send-email-nikitas_angelinas@xyratex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317339500-4341-3-git-send-email-nikitas_angelinas@xyratex.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 12:38:20AM +0100, Nikitas Angelinas wrote:
> Current logic would print an error message only once, and then
> 'failed_writes' would stay at 1. Rework the loop to increment
> 'failed_writes' and print the error message every s_mmp_update_interval
> * 60 seconds, as intended according to the comment.
> 
> Perhaps it would be better to reset 'failed_writes' to 0 on every
> successful write, such that new errors are noticed sooner, but maybe in
> the interest of efficiency it would be best not to add an operation on
> every kmmpd thread run?
> 
> Signed-off-by: Nikitas Angelinas <nikitas_angelinas@xyratex.com>
> Signed-off-by: Andrew Perepechko <andrew_perepechko@xyratex.com>
> Acked-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

						- Ted
