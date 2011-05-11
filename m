Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831Ab1EKQ5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:57:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65322 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab1EKQ5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PAmIZAlZBMqXW/P1hvKMQP/knlxHlCZvVtb715VybTs6tH7BIHlUQyZfMy1enCwATV
         l8nwyUSIRT81oXkvzFR7312l1JeU/5lzxqM47tfB22BbBv2+NQNzt2W+kCv1hT/yqZJK
         V1GsBZzJ7AOQuz2LC8H30PBN8QOH/nBeQQjYc=
Date: Wed, 11 May 2011 11:28:48 +0200
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        eric.dumazet@gmail.com, cl@linux.com, npiggin@kernel.dk
Subject: Re: [patch v2 0/5] percpu_counter: bug fix and enhancement
Message-ID: <20110511092848.GE1661@htj.dyndns.org>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511081012.903869567@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Shaohua.

On Wed, May 11, 2011 at 04:10:12PM +0800, Shaohua Li wrote:
> The new implementation uses lglock to protect percpu data. Each cpu has its
> private lock while other cpu doesn't take. In this way _add doesn't need take
> global lock anymore and remove the deviation. This still gives me about
> about 5x ~ 6x faster (not that faster than the original 7x faster, but still
> good) with the workload mentioned in patch 4.

I'm afraid I'm not too thrilled about lglock + atomic64 usage.  It is
a very patchy approach which addresses a very specific use case which
might just need a higher @batch.  I just can't see enough benefits to
justify the overhead and complexity.  :-(

Thanks.

-- 
tejun
