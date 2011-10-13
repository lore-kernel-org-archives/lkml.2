Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab1JMABa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:01:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29100 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1JMAB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:01:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=XLJRINfCNvHcKVh2fFPY2DnUXqUhJBWfubB2U1M/YPTcg3wChfa13t5+6FULDWm21
	kmNDhR7VPSOFkpfabn9gQ==
Date: Wed, 12 Oct 2011 17:01:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Satoru Moriya <satoru.moriya@hds.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, Hugh Dickins <hughd@google.com>,
        hannes@cmpxchg.org
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9CB516D0EA@USINDEVS02.corp.hds.com>
Message-ID: <alpine.DEB.2.00.1110121654120.30123@chino.kir.corp.google.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com> <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com> <20111010153723.6397924f.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com> <20111011125419.2702b5dc.akpm@linux-foundation.org> <65795E11DBF1E645A09CEC7EAEE94B9CB516CBFE@USINDEVS02.corp.hds.com> <20111011135445.f580749b.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516D055@USINDEVS02.corp.hds.com> <alpine.DEB.2.00.1110121537380.16286@chino.kir.corp.google.com> <65795E11DBF1E645A09CEC7EAEE94B9CB516D0EA@USINDEVS02.corp.hds.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011, Satoru Moriya wrote:

> > I think the point was that extra_free_kbytes needs to be tuned to 
> > cover at least the amount of memory of the largest allocation burst
> 
> Right. In enterprise area, we strictly test the system we build
> again and again before we release it. In that situation, we can
> set extra_free_kbytes appropriately based on system's requirements
> and/or specifications etc.
> 

You would also need to guarantee that min_free_kbytes isn't subsequently 
changed because that would change the value that extra_free_kbytes would 
need to preserve the same exclusive access to memory that the rt threads 
would have without increasing it.

> I understand what you concern. But in some area such as banking,
> stock exchange, train/power/plant control sysemts etc this kind
> of tunable is welcomed because they can tune their systems at
> their own risk.
> 

You haven't tried the patch that increases the priority of kswapd when 
such a latency sensitive thread triggers background reclaim?
