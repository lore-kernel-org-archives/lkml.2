Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab2CGPok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:44:40 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:37411 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758845Ab2CGPoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:44:38 -0500
Date: Wed, 7 Mar 2012 08:44:36 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] [SCSI] sd: set BIO_MAPPED_INTEGRITY bit correctly in
	sd_dif_prepare().
Message-ID: <20120307154436.GB19570@parisc-linux.org>
References: <1331131295-3707-1-git-send-email-santoshprasadnayak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331131295-3707-1-git-send-email-santoshprasadnayak@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 08:11:35PM +0530, santosh nayak wrote:
> -		bio->bi_flags |= BIO_MAPPED_INTEGRITY;
> +		set_bit(BIO_MAPPED_INTEGRITY, &bio->bi_flags);

This uses an atomic operation; you should rather use __set_bit instead.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
