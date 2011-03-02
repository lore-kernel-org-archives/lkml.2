Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab1CBJRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 04:17:38 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48933 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab1CBJRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 04:17:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IcUpkRbp4TPcbu1U80vFp8/4SHkXbJTODE9vlPAZiWYgAqxo1bCQvSg8CtTE//TRzu
         6wV8OatWqa3dCITIuBxPt5PVolCINgDPFqfECMmhBwLOgjKgVZOcaggOkvvUYCfjy9/W
         b5tT0n2OQ5n3DBX0IFkxkZCTrZI9ZHl/Cg17c=
Date: Wed, 2 Mar 2011 10:17:31 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL tip:x86/mm]
Message-ID: <20110302091731.GJ19669@htj.dyndns.org>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
 <4D6D70E1.40808@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6D70E1.40808@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Yinghai.

On Tue, Mar 01, 2011 at 02:19:13PM -0800, Yinghai Lu wrote:
> after looking at the code, it seems the cleanup does have several problems:
> 1. need to reserve temp numa dist.
> 	We only can use find_...without_reserve tricks when we are done with
> 	 the old one before get another new one.

Indeed, thanks for catching this.

> 2. during copying should only copy with NEW numa_dist_cnt size.
> 	so need to call numa_alloc_dist at first before copy.

It doesn't matter.  numa_set_distance() ignores distances for nodes
which are out of scope.

> 3. phys_dist whould numa_dist_cnt square size
> 4. numa_reset_distance should free numa_dist_cnt square size

Yeah, I seem to have completely forgotten about the square thing.
Stupid.

I'll regenerate patches with changes for 1, 3 and 4.  For 2, I'll add
comments explaining why it's okay.

Thanks.

-- 
tejun
