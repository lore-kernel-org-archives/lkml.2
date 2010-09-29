Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0I2RTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 13:19:38 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:48302 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab0I2RTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 13:19:37 -0400
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOMRo0yrR7Hu/2dsb2JhbACiGXGrTZxuhUQEhFCFaoR5
X-IronPort-AV: E=Sophos;i="4.57,254,1283731200"; 
   d="scan'208";a="281895738"
From: Roland Dreier <rdreier@cisco.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/cxgb4: Add default_llseek to debugfs files.
References: <20100929141112.26944.21931.stgit@build.ogc.int>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 29 Sep 2010 10:19:32 -0700
In-Reply-To: <20100929141112.26944.21931.stgit@build.ogc.int> (Steve Wise's
	message of "Wed, 29 Sep 2010 09:11:12 -0500")
Message-ID: <adawrq431sr.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > @@ -182,6 +182,7 @@ static const struct file_operations qp_debugfs_fops = {
 >  	.open    = qp_open,
 >  	.release = qp_release,
 >  	.read    = debugfs_read,
 > +	.llseek  = default_llseek,
 >  };

I think this could actually be generic_file_llseek (right, Arnd?).

Also could qp_read() and other read methods be simplified by using
simple_read_from_buffer()?  I don't see anything fancy there, seems like
the read methods could become one-liners that way.

 - R.
