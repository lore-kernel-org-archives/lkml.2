Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab1DMTH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:07:56 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37351 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab1DMTHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L2jAlQdMvXiUMzWMSQZMU02PCvly4QLCXh5XbXW+d96SLKmt3dfwEJD1707Ig6BPCA
         hzXZN/61gErYT96i/zWXjvR+3wu6M5O5FFA8FeWVa3tP5hAFaqzydmUB0fIr52FQih9D
         DWmO5J8bq9x4Sr3WhhraxQ7aFr6kvpNWPd404=
Date: Thu, 14 Apr 2011 04:07:47 +0900
From: Tejun Heo <tj@kernel.org>
To: shaohua.li@intel.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, cl@linux.com,
        eric.dumazet@gmail.com
Subject: Re: [patch v2 4/4] percpu_counter: use atomic64 for counter
Message-ID: <20110413190747.GE3987@mtj.dyndns.org>
References: <20110413075715.090406229@sli10-conroe.sh.intel.com>
 <20110413080517.901701497@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413080517.901701497@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 03:57:19PM +0800, shaohua.li@intel.com wrote:
> This can improve some workloads with percpu_counter->lock heavily contented.
> For example, vm_committed_as sometimes causes the contention. We should tune
> the batch count, but if we can make percpu_counter better, why not? In a 24
> CPUs system, 24 processes run stress mmap()/mmunmap(), the atomic method
> gives 50x faster.

Christoph already raised the issue but I'd also love to know a bit
more detail on the test than "50x faster".

Thanks.

-- 
tejun
