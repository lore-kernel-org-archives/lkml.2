Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab1DSVXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:23:45 -0400
Received: from smtp-out.google.com ([74.125.121.67]:56348 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab1DSVXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:23:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Yqt7VziEFl8ZY1c7GI3h0x5crwkVUQs2N3YLogSFaRol3ycfP7k0qM1XCupm1Jm3Qb
         V6YVr+ezxKpf87Jav/8g==
Date: Tue, 19 Apr 2011 14:23:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] break out page allocation warning code
In-Reply-To: <1303160221.9887.301.camel@nimitz>
Message-ID: <alpine.DEB.2.00.1104191422080.510@chino.kir.corp.google.com>
References: <20110415170437.17E1AF36@kernel> <alpine.DEB.2.00.1104161653220.14788@chino.kir.corp.google.com> <1303139455.9615.2533.camel@nimitz> <alpine.DEB.2.00.1104181321480.31186@chino.kir.corp.google.com> <1303160221.9887.301.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011, Dave Hansen wrote:

> > It shouldn't be a follow-on patch since you're introducing a new feature 
> > here (vmalloc allocation failure warnings) and what I'm identifying is a 
> > race in the access to current->comm.  A bug fix for a race should always 
> > preceed a feature that touches the same code.
> 
> Dude.  Seriously.  Glass house!  a63d83f4
> 

Not sure what you're implying here.  The commit you've identified is the 
oom killer rewrite and the oom killer is very specific about making sure 
to always hold task_lock() whenever dereferencing ->comm, even for 
current, to guard against /proc/pid/comm or prctl().  The oom killer is 
different from your usecase, however, because we can always take 
task_lock(current) in the oom killer because it's in a blockable context, 
whereas page allocation warnings can occur in a superset.
