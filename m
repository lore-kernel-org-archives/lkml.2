Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0I2SwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 14:52:20 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:36932 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab0I2SwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 14:52:19 -0400
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAK8no0yrRN+J/2dsb2JhbACiHHGrRJxwhUQEhFCFaoR5
X-IronPort-AV: E=Sophos;i="4.57,255,1283731200"; 
   d="scan'208";a="240743337"
From: Roland Dreier <rdreier@cisco.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: stable@kernel.org, linux-rdma@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/cxgb4: Add default_llseek to debugfs files.
References: <20100929141112.26944.21931.stgit@build.ogc.int>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 29 Sep 2010 11:52:10 -0700
In-Reply-To: <20100929141112.26944.21931.stgit@build.ogc.int> (Steve Wise's
	message of "Wed, 29 Sep 2010 09:11:12 -0500")
Message-ID: <ada8w2k2xid.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > --- a/drivers/infiniband/hw/cxgb4/device.c
 > +++ b/drivers/infiniband/hw/cxgb4/device.c
 > @@ -182,6 +182,7 @@ static const struct file_operations qp_debugfs_fops = {
 >  	.open    = qp_open,
 >  	.release = qp_release,
 >  	.read    = debugfs_read,
 > +	.llseek  = default_llseek,
 >  };
 >  
 >  static int dump_stag(int id, void *p, void *data)
 > @@ -255,6 +256,7 @@ static const struct file_operations stag_debugfs_fops = {
 >  	.open    = stag_open,
 >  	.release = stag_release,
 >  	.read    = debugfs_read,
 > +	.llseek  = default_llseek,
 >  };
 >  
 >  static int setup_debugfs(struct c4iw_dev *devp)
 > 
 > 

Steve, can you also do a quick test to make sure this works OK with
generic_file_llseek instead of default_llseek?

Thanks.
