Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1JLUVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 16:21:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46763 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab1JLUVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 16:21:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=PXh2c2pRTDFKI1eCVbhNH4uFbHQXymlJ4I+R6eafNYDbtyyv1M49o3D7RZmxfgdIY
	0SC07VFQ423t+IaPInthg==
Date: Wed, 12 Oct 2011 13:21:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rik van Riel <riel@redhat.com>
cc: Satoru Moriya <satoru.moriya@hds.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [PATCH -v2 -mm] add extra free kbytes tunable
In-Reply-To: <4E959292.9060301@redhat.com>
Message-ID: <alpine.DEB.2.00.1110121316590.7646@chino.kir.corp.google.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com> <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com> <65795E11DBF1E645A09CEC7EAEE94B9CB516CBBC@USINDEVS02.corp.hds.com>
 <alpine.DEB.2.00.1110111343070.29761@chino.kir.corp.google.com> <4E959292.9060301@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011, Rik van Riel wrote:

> How would this scheme work?
> 

I suggested a patch from BFS that would raise kswapd to the same priority 
of the task that triggered it (not completely up to rt, but the highest 
possible in that case) and I'm waiting to hear if that helps for Satoru's 
test case before looking at alternatives.  We could also extend the patch 
to raise the priority of an already running kswapd if a higher priority 
task calls into the page allocator's slowpath.
