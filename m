Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab2GHOxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 10:53:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:30686 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab2GHOxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 10:53:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174728631"
Date: Sun, 8 Jul 2012 22:53:09 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, yinghan@google.com,
        akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 6/7] memcg: add per cgroup writeback pages accounting
Message-ID: <20120708145309.GC18272@localhost>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
 <1340881562-5900-1-git-send-email-handai.szj@taobao.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340881562-5900-1-git-send-email-handai.szj@taobao.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -2245,7 +2252,10 @@ int test_set_page_writeback(struct page *page)
>  {
>  	struct address_space *mapping = page_mapping(page);
>  	int ret;
> +	bool locked;
> +	unsigned long flags;
>  
> +	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
>  	if (mapping) {
>  		struct backing_dev_info *bdi = mapping->backing_dev_info;
>  		unsigned long flags;
> @@ -2272,6 +2282,8 @@ int test_set_page_writeback(struct page *page)
>  	}
>  	if (!ret)
>  		account_page_writeback(page);
> +
> +	mem_cgroup_end_update_page_stat(page, &locked, &flags);
>  	return ret;
>  
>  }

Where is the MEM_CGROUP_STAT_FILE_WRITEBACK increased?

Thanks,
Fengguang
