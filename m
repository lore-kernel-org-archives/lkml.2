Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab1DMDLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 23:11:39 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:47223 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab1DMDLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 23:11:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZvfK3so+wXz4Y6nQ3awcvP98LRIqplM+96iuuYEuVJmHeFW/F6+sU6IudIJcHXSYY3
         IomKaRypOV2SG0RSNDuZufNoRtR5oaEa4MnR3ZFD0st9rBXT8HDD2MZDn/H10jPFtetO
         vVCQc1oO0rdHG1dg5fMVVhoQU/OAcB2sJH410=
Date: Wed, 13 Apr 2011 12:11:30 +0900
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>
Subject: Re: [PATCH 4/4]percpu_counter: use atomic64 for counter
Message-ID: <20110413031130.GH16342@mtj.dyndns.org>
References: <1302595446.3981.130.camel@sli10-conroe>
 <20110412191534.GE16342@mtj.dyndns.org>
 <1302657428.3981.149.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302657428.3981.149.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 13, 2011 at 09:17:08AM +0800, Shaohua Li wrote:
> yes, we do have something this matters. the vm_committed_as
> percpu_counter could heavily contend the lock. please see
> http://marc.info/?l=linux-kernel&m=130144786026044&w=2
> We should fix vm_committed_as, but the atomic method also gives me very
> good output. When I do mmap/munmap test in a 24 CPU system, the atomic
> method gives me 50x faster.

That's good to hear.  Care to provide the performance info in the
commit message too?

Thanks.

-- 
tejun
