Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab0ESMMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:12:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:53961 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab0ESMML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:12:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,263,1272870000"; 
   d="scan'208";a="622961022"
Date: Wed, 19 May 2010 20:12:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, mem-hotplug: update all PGDs for direct
 mapping and vmemmap mapping changes on 64bit.
Message-ID: <20100519121202.GB23778@localhost>
References: <4BF3D15F.1000604@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF3D15F.1000604@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1033,6 +1038,7 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
>   		}
> 
>   	}
> +	sync_global_pgds((unsigned long)start_page, end);

Here you removed the tlb flush in the original patch. Is it safe to do so?

Thanks,
Fengguang
