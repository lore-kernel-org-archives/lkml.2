Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1JWVWf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 17:22:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7312 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1JWVWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 17:22:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=SLwMqqW0g4bGxrPLvecJ/MfvBST7hRwoHjllMH6uCkm7jaKNy/FlUFVdYxJcfWn5+
	DZk7U8jlZ2b+TllCio3QQ==
Date: Sun, 23 Oct 2011 14:22:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Satoru Moriya <satoru.moriya@hds.com>
cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        "hughd@google.com" <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9CB4F747B1@USINDEVS02.corp.hds.com>
Message-ID: <alpine.DEB.2.00.1110231419070.17218@chino.kir.corp.google.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com> <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com> <20111010153723.6397924f.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com> <20111011125419.2702b5dc.akpm@linux-foundation.org> <65795E11DBF1E645A09CEC7EAEE94B9CB516CBFE@USINDEVS02.corp.hds.com> <20111011135445.f580749b.akpm@linux-foundation.org> <4E95917D.3080507@redhat.com>
 <20111012122018.690bdf28.akpm@linux-foundation.org>,<4E95F167.5050709@redhat.com> <65795E11DBF1E645A09CEC7EAEE94B9CB4F747B1@USINDEVS02.corp.hds.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Oct 2011, Satoru Moriya wrote:

> We do.
> Basically we need this kind of feature for almost all our latency
> sensitive applications to avoid latency issue in memory allocation.
> 

These are all realtime?

> Currently we run those applications on custom kernels which this
> kind of patch is applied to. But it is hard for us to support every
> kernel version for it. Also there are several customers who can't
> accept a custom kernel and so they must use other commercial Unix.
> If this feature is accepted, they will definitely use it on their
> systems.
> 

That's precisely the problem, it's behavior is going to vary widely from 
version to version as the implementation changes for reclaim and 
compaction.  I think we can do much better with the priority of kswapd and 
reclaiming above the high watermark for threads that need a surplus of 
extra memory because they are realtime, two things we can easily do.
