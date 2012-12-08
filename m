Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030244Ab2LHTnP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 14:43:15 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51147 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030221Ab2LHTnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 14:43:13 -0500
Date: Sat, 8 Dec 2012 11:45:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: add node physical memory range to sysfs
Message-ID: <20121208194528.GB3897@kroah.com>
References: <1354919696.2523.6.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354919696.2523.6.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 02:34:56PM -0800, Davidlohr Bueso wrote:
> This patch adds a new 'memrange' file that shows the starting and
> ending physical addresses that are associated to a node. This is
> useful for identifying specific DIMMs within the system.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> ---
>  drivers/base/node.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index af1a177..f165a0a 100644
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
> +
> +	return sprintf(buf, "%#010Lx-%#010Lx\n",
> +		       (unsigned long long) start_pfn << PAGE_SHIFT,
> +		       (unsigned long long) (end_pfn << PAGE_SHIFT) - 1);
> +}
> +static DEVICE_ATTR(memrange, S_IRUGO, node_read_memrange, NULL);

As you're adding a new sysfs file, we need a Documentation/ABI/ entry as
well.  Yes, the existing ones aren't there already, as Andrew points
out, sorry, but that means you get to document them all :)

thanks,

greg k-h
