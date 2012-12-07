Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab2LGXv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 18:51:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab2LGXv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 18:51:26 -0500
Date: Fri, 7 Dec 2012 15:51:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: add node physical memory range to sysfs
Message-Id: <20121207155125.d3117244.akpm@linux-foundation.org>
In-Reply-To: <1354919696.2523.6.camel@buesod1.americas.hpqcorp.net>
References: <1354919696.2523.6.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Dec 2012 14:34:56 -0800
Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:

> This patch adds a new 'memrange' file that shows the starting and
> ending physical addresses that are associated to a node. This is
> useful for identifying specific DIMMs within the system.

I was going to bug you about docmentation, but apparently we didn't
document /sys/devices/system/node/node*/.  A great labor-saving device,
that!

> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -211,6 +211,19 @@ static ssize_t node_read_distance(struct device *dev,
>  }
>  static DEVICE_ATTR(distance, S_IRUGO, node_read_distance, NULL);
>  
> +static ssize_t node_read_memrange(struct device *dev,
> +				  struct device_attribute *attr, char *buf)
> +{
> +	int nid = dev->id;
> +	unsigned long start_pfn = NODE_DATA(nid)->node_start_pfn;
> +	unsigned long end_pfn = start_pfn + NODE_DATA(nid)->node_spanned_pages;

hm.  Is this correct for all for
FLATMEM/SPARSEMEM/SPARSEMEM_VMEMMAP/DISCONTIGME/etc?


