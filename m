Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab0IMDDF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 23:03:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:41320 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0IMDDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 23:03:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,357,1280732400"; 
   d="scan'208";a="656596301"
Date: Mon, 13 Sep 2010 11:02:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Michael Rubin <mrubin@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 4/5] writeback: Adding
 /sys/devices/system/node/<node>/vmstat
Message-ID: <20100913030256.GC7697@localhost>
References: <1284323440-23205-1-git-send-email-mrubin@google.com>
 <1284323440-23205-5-git-send-email-mrubin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284323440-23205-5-git-send-email-mrubin@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 04:30:39AM +0800, Michael Rubin wrote:
> For NUMA node systems it is important to have visibility in memory
> characteristics. Two of the /proc/vmstat values "nr_cleaned" and

s/nr_cleaned/nr_written/

> "nr_dirtied" are added here.
> 
> 	# cat /sys/devices/system/node/node20/vmstat
> 	nr_cleaned 0

ditto

> 	nr_dirtied 0
> 
> Signed-off-by: Michael Rubin <mrubin@google.com>

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

> +static ssize_t node_read_vmstat(struct sys_device *dev,
> +				struct sysdev_attribute *attr, char *buf)
> +{
> +	int nid = dev->id;
> +	return sprintf(buf,
> +		"nr_written %lu\n"
> +		"nr_dirtied %lu\n",
> +		node_page_state(nid, NR_WRITTEN),
> +		node_page_state(nid, NR_FILE_DIRTIED));
> +}

Do you have plan to port more vmstat_text[] items? :)

Thanks,
Fengguang
