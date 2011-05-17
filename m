Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1EQJuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:50:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61224 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab1EQJuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vVLhtmYULSRUK0/Pwsip3Lb3SHtWt2IpvCwXX5RtkPmbNZkXY/p+DMkOltCs2yruV+
         NF1pyStUVGKql/PUJgLVgHndYmSlIKxpwiQdMPZ852VQmZzEMF+Dq/5JqwFiXW0HFvXE
         MXIqmj5ECm7U3qYX1XDPatlGX6Fzr6kuNziac=
Date: Tue, 17 May 2011 11:50:01 +0200
From: Tejun Heo <tj@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
Subject: Re: [patch V3] percpu_counter: scalability works
Message-ID: <20110517095001.GF20624@htj.dyndns.org>
References: <1305531877.3120.230.camel@edumazet-laptop>
 <1305534857.2375.55.camel@sli10-conroe>
 <1305538504.2898.33.camel@edumazet-laptop>
 <1305555736.2898.46.camel@edumazet-laptop>
 <1305593751.2375.69.camel@sli10-conroe>
 <1305608212.9466.45.camel@edumazet-laptop>
 <1305609768.2375.84.camel@sli10-conroe>
 <1305622861.2850.21.camel@edumazet-laptop>
 <20110517091102.GE20624@htj.dyndns.org>
 <1305625541.2850.29.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305625541.2850.29.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

On Tue, May 17, 2011 at 11:45:41AM +0200, Eric Dumazet wrote:
> _sum() is a bit more precise than percpu_counter_read(), but to make it
> really precise, we means we have to stop concurrent activities, and we
> never did in previous/current implementation.
> 
> We could add this (as Shaohua and myself tried in various patches)
> later, if needed, but nowhere in kernel we currently need that.
> 
> Even /proc/meminfo doesnt call _sum(&vm_committed_as) but the lazy
> percpu_counter_read_positive() function...
> 
> Reammy _sum() gives a good approximation of the counter, more precise
> because of the percpu s32 folding, but no guarantee of deviation.

I'm not asking to make it more accurate but the initial patches from
Shaohua made the _sum() result to deviate by @batch even when only one
thread is doing _inc() due to the race window between adding to the
main counter and resetting the local one.  All I'm asking is closing
that hole and I'll be completely happy with it.  The lglock does that
but it's ummm.... not a very nice way to do it.

Please forget about deviations from concurrent activities.  I don't
care and nobody should.  All I'm asking is removing that any update
having the possibility of that unnecessary spike and I don't think
that would be too hard.

Thanks.

-- 
tejun
