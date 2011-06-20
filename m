Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab1FTTMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:12:13 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:26701 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab1FTTML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:12:11 -0400
X-IronPort-AV: E=Sophos;i="4.65,395,1304294400"; 
   d="scan'208";a="6385235"
Date: Mon, 20 Jun 2011 20:16:01 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ian Jackson <Ian.Jackson@eu.citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/3] x86: calculate precisely the memory
 needed by init_memory_mapping
In-Reply-To: <19963.35531.684825.285975@mariner.uk.xensource.com>
Message-ID: <alpine.DEB.2.00.1106202008390.12963@kaball-desktop>
References: <alpine.DEB.2.00.1106071849290.12963@kaball-desktop> <m2n.s.1QU0lc-137774@chiark.greenend.org.uk> <19963.35531.684825.285975@mariner.uk.xensource.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011, Ian Jackson wrote:
> stefano.stabellini@eu.citrix.com writes ("[Xen-devel] [PATCH 1/3] x86: calculate precisely the memory needed by init_memory_mapping"):
> > +	if (pgt_buf_end != pgt_buf_top)
> > +		printk(KERN_DEBUG "initial kernel pagetable allocation wasted %lx"
> > +				" pages\n", pgt_buf_top - pgt_buf_end);
> 
> If (due to a bug) pgt_buf_end > pgt_buf_top, this will printk a
> message about wasting a negative number of pages, rather than
> crashing.  Is there something else that will catch this case ?

Thanks for reviewing this patch!

Yes, there is something else that catches this case: both the 32 bit
and the 64 bit versions of alloc_low_page contain this code:


unsigned long pfn = pgt_buf_end++;

if (pfn >= pgt_buf_top)
		panic("alloc_low_page: ran out of memory");


so we are safe from that point of view.
