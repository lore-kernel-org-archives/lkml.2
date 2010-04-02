Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab0DBSSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:18:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab0DBSSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:18:07 -0400
Date: Fri, 2 Apr 2010 14:17:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Subject: Re: [PATCH 2/3] blkio: Add io controller stats like
Message-ID: <20100402181754.GC3516@redhat.com>
References: <20100401215541.2843.79107.stgit@austin.mtv.corp.google.com> <20100401220109.2843.36040.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401220109.2843.36040.stgit@austin.mtv.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 03:01:24PM -0700, Divyesh Shah wrote:

[..]
> +#define GET_STAT(__VAR, __CONV)						\
> +uint64_t get_##__VAR##_stat(struct blkio_group *blkg, int dummy)	\
> +{									\
> +	uint64_t data = blkg->stats.__VAR;				\
> +	if (__CONV)							\
> +		data = (uint64_t)jiffies_to_msecs(data) * NSEC_PER_MSEC;\
> +	return data;							\
> +}
> +

Hi Divyesh,

I think now you are exporting blkio.time in ns instead of ms? 

- First of all your are breaking ABI.
- Secondly, how does that help. You are capturing all your slice used
  stats in ms. You already lost any ns granularity. What's the point
  in converting these to ns now?
- Does user space software really need that fine grained accounting. If
  this information is used for charging purposes, isn't ms good enough.
 
Thanks
Vivek
