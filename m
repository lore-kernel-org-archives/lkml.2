Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab1AMWZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:25:26 -0500
Received: from smtp-out.google.com ([74.125.121.67]:25758 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1AMWZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:25:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=oP83km1uN7UzmLE6KR/4CnNemfvOdveq4wtWoVHcdLesC+0pZlWEg7KhkOoCjHw0Kr
         g0WPLeoq7EsZ1Ny/yD/A==
Date: Thu, 13 Jan 2011 14:24:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Satoru Moriya <satoru.moriya@hds.com>
cc: Ying Han <yinghan@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Randy Dunlap <rdunlap@xenotime.net>, dle-develop@lists.sourceforge.net,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: RE: [RFC][PATCH 0/2] Tunable watermark
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9C3B8DF647@USINDEVS02.corp.hds.com>
Message-ID: <alpine.DEB.2.00.1101131421220.26770@chino.kir.corp.google.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9C3A30A295@USINDEVS02.corp.hds.com> <alpine.DEB.2.00.1101071416450.23577@chino.kir.corp.google.com> <AANLkTikQPXWkEJwN5fV2vnUS37Fs+GNzFXuFkKXcnzmu@mail.gmail.com> <alpine.DEB.2.00.1101071436220.23858@chino.kir.corp.google.com>
 <65795E11DBF1E645A09CEC7EAEE94B9C3B8DF647@USINDEVS02.corp.hds.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Satoru Moriya wrote:

> Currently watermark[low,high] are set by following calculation (lowmem case).
> 
> watermark[low]  = watermark[min] * 1.25
> watermark[high] = watermark[min] * 1.5
> 
> So the difference between watermarks are following:
> 
> min <-- min/4 --> low <-- min/4 --> high
> 
> I think the differences, "min/4", are too small in my case.
> Of course I can make them bigger if I set min_free_kbytes to bigger value. 
> But it means kernel keeps more free memory for PF_MEMALLOC case unnecessarily.
> 
> So I suggest changing coefficients(1.25, 1.5). Also it's better
> to make them accessible from user space to tune in response to application
> requirements.
> 

Userspace can't possibly be held responsible for tuning internal VM 
parameters in response to certain workloads like this; if you have 
evidence that different coefficients work better in different 
circumstances, then present the criteria for which you intend to change 
them from the command line via your new tunables and let's work to make 
the VM more extendable to serve those workloads well.  This should be done 
by showing how background reclaim is ineffective, we enter direct 
compaction or reclaim too aggressively, we don't wait for writeout long 
enough, we prematurely kill applications when unnecessary, etc, which 
would undoubtedly have if you're going to make any sane adjustments via 
these new tunables.
