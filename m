Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab2E1SYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 14:24:44 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:46040 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2E1SYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 14:24:42 -0400
Date: Mon, 28 May 2012 14:24:38 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Haogang Chen <haogangchen@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FS: ext4: fix integer overflow in alloc_flex_gd()
Message-ID: <20120528182438.GL19152@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Haogang Chen <haogangchen@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1329777684-18396-1-git-send-email-haogangchen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329777684-18396-1-git-send-email-haogangchen@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 05:41:24PM -0500, Haogang Chen wrote:
> In alloc_flex_gd(), when flexbg_size is large, kmalloc size would
> overflow and flex_gd->groups would point to a buffer smaller than
> expected, causing OOB accesses when it is used.
> 
> Note that in ext4_resize_fs(), flexbg_size is calculated using
> sbi->s_log_groups_per_flex, which is read from the disk and only bounded
> to [1, 31]. The patch returns NULL for too large flexbg_size.
> 
> Signed-off-by: Haogang Chen <haogangchen@gmail.com>

Thanks, applied.  Apologies for missing this during the last cycle.

		  	    		     - Ted
