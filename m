Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab0J2LNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 07:13:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:25784 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334Ab0J2LNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 07:13:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,259,1286175600"; 
   d="scan'208";a="342076269"
Date: Fri, 29 Oct 2010 19:13:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "containers@lists.osdl.org" <containers@lists.osdl.org>,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v4 06/11] memcg: add dirty page accounting
 infrastructure
Message-ID: <20101029111300.GB29774@localhost>
References: <1288336154-23256-1-git-send-email-gthelen@google.com>
 <1288336154-23256-7-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288336154-23256-7-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 03:09:09PM +0800, Greg Thelen wrote:

> +
> +	case MEMCG_NR_FILE_DIRTY:
> +		/* Use Test{Set,Clear} to only un/charge the memcg once. */
> +		if (val > 0) {
> +			if (TestSetPageCgroupFileDirty(pc))
> +				val = 0;
> +		} else {
> +			if (!TestClearPageCgroupFileDirty(pc))
> +				val = 0;
> +		}

I'm wondering why TestSet/TestClear and even the cgroup page flags for
dirty/writeback/unstable pages are necessary at all (it helps to
document in changelog if there are any). For example, VFS will call
TestSetPageDirty() before calling
mem_cgroup_inc_page_stat(MEMCG_NR_FILE_DIRTY), so there should be no
chance of false double counting.

Thanks,
Fengguang
