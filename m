Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab2BVP7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:59:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38510 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2BVP7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:59:31 -0500
Subject: Re: [PATCH] FS: nilfs2: clamps ns_r_segments_percentage to [1, 99]
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <20120223.004650.160012804.ryusuke@osrg.net>
Date: Wed, 22 Feb 2012 10:59:25 -0500
Cc: haogangchen@gmail.com, linux-nilfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <EC48BE45-EA3E-400B-A90D-FF05CE3426D8@gmail.com>
References: <1329774930-17162-1-git-send-email-haogangchen@gmail.com> <20120223.004650.160012804.ryusuke@osrg.net>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 22, 2012, at 10:46 AM, Ryusuke Konishi wrote:
> But this seems not to cause security issues; it just makes some disk
> usage calculations meaningless and causes malfunction for such
> out-of-range values.  Right?

Seems true to me.

There may be another issue a few lines above: ns_blocks_per_segment
doesn't seem to have an upper bound (though it has a lower bound
NILFS_SEG_MIN_BLOCKS).  ns_blocks_per_segment is used in several
multiplications, such as in nilfs_ioctl_clean_segments:

if (argv[n].v_nmembs > nsegs * nilfs->ns_blocks_per_segment
        goto out_free;

Will this cause any problem?  Or is there any reasonable upper bound
for ns_blocks_per_segment?

- xi

