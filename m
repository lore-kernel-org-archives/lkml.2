Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab1EQJLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:11:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab1EQJLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:11:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hAkhbDO8/y9LOHOse6sTy7CbZRv/xpYGG1wJQOdXxxu5R74HuSjXQW83f7ldCseXDv
         /kQvkTBDzz6oy4RQOuJj9URASU3l5SdjpGrkgZUC7VNzlLcqmRhBZm3ZQNs1Jlj27c9G
         t+zN27kvjWf1i5ad4WgRFpyvAGDsS0NMj2bko=
Date: Tue, 17 May 2011 11:11:02 +0200
From: Tejun Heo <tj@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
Subject: Re: [patch V3] percpu_counter: scalability works
Message-ID: <20110517091102.GE20624@htj.dyndns.org>
References: <1305528912.3120.213.camel@edumazet-laptop>
 <1305530143.2375.42.camel@sli10-conroe>
 <1305531877.3120.230.camel@edumazet-laptop>
 <1305534857.2375.55.camel@sli10-conroe>
 <1305538504.2898.33.camel@edumazet-laptop>
 <1305555736.2898.46.camel@edumazet-laptop>
 <1305593751.2375.69.camel@sli10-conroe>
 <1305608212.9466.45.camel@edumazet-laptop>
 <1305609768.2375.84.camel@sli10-conroe>
 <1305622861.2850.21.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305622861.2850.21.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric, Shaohua.

On Tue, May 17, 2011 at 11:01:01AM +0200, Eric Dumazet wrote:
> Just convince him that percpu_counter by itself cannot bring a max
> deviation guarantee. No percpu_counter user cares at all. If they do,
> then percpu_counter choice for their implementation is probably wrong.
> 
> [ We dont provide yet a percpu_counter_add_return() function ]

I haven't gone through this thread yet but will do so later today, but
let me clarify the whole deviation thing.

1. I don't care reasonable (can't think of a better word at the
   moment) level of deviation.  Under high level of concurrency, the
   exact value isn't even well defined - nobody can tell operations
   happened in what order anyway.

2. But I _do_ object to _sum() has the possibility of deviating by
   multiples of @batch even with very low level of activity.

I'm completely fine with #1.  I'm not that crazy but I don't really
want to take #2 - that makes the whole _sum() interface almost
pointless.  Also, I don't want to add big honking lglock to just avoid
#2 unless it can be shown that the same effect can't be achieved in
saner manner and I'm highly skeptical that would happen.

Thank you.

-- 
tejun
