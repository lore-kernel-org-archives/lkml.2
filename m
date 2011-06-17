Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142Ab1FQRLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 13:11:43 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:32621 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab1FQRLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 13:11:42 -0400
X-IronPort-AV: E=Sophos;i="4.65,382,1304294400"; 
   d="scan'208";a="6344961"
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <19963.35531.684825.285975@mariner.uk.xensource.com>
Date: Fri, 17 Jun 2011 18:11:39 +0100
To: <stefano.stabellini@eu.citrix.com>
CC: <hpa@zytor.com>, <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <hpa@linux.intel.com>,
        <yinghai@kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/3] x86: calculate precisely the memory needed
	by init_memory_mapping
Newsgroups: chiark.mail.xen.devel
In-Reply-To: <m2n.s.1QU0lc-137774@chiark.greenend.org.uk>
References: <alpine.DEB.2.00.1106071849290.12963@kaball-desktop>
	<m2n.s.1QU0lc-137774@chiark.greenend.org.uk>
X-Mailer: VM 8.0.9 under Emacs 21.4.1 (i486-pc-linux-gnu)
From: Ian Jackson <Ian.Jackson@eu.citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stefano.stabellini@eu.citrix.com writes ("[Xen-devel] [PATCH 1/3] x86: calculate precisely the memory needed by init_memory_mapping"):
> +	if (pgt_buf_end != pgt_buf_top)
> +		printk(KERN_DEBUG "initial kernel pagetable allocation wasted %lx"
> +				" pages\n", pgt_buf_top - pgt_buf_end);

If (due to a bug) pgt_buf_end > pgt_buf_top, this will printk a
message about wasting a negative number of pages, rather than
crashing.  Is there something else that will catch this case ?

Ian.
