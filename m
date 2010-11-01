Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab0KATg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:36:29 -0400
Received: from smtp-out.google.com ([74.125.121.35]:46039 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab0KATg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:36:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=NMponrh3oAUCaK9qTMy1+k+SSVSCLshHHF/tISIdBJwAD1hb3IF5veCNNf4CTgsRN8
         Zvbg8Pb3nJcEUH9JZx8Q==
Date: Mon, 1 Nov 2010 12:36:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH 2/4] Revert "oom: deprecate oom_adj tunable"
In-Reply-To: <20101101030353.607A.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011011232120.6822@chino.kir.corp.google.com>
References: <20101026220237.B7DA.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1010261234230.5578@chino.kir.corp.google.com> <20101101030353.607A.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010, KOSAKI Motohiro wrote:

> > The new tunable added in 2.6.36, /proc/pid/oom_score_adj, is necessary for 
> > the units that the badness score now uses.  We need a tunable with a much 
> 
> Who we?
> 

Linux users who care about prioritizing tasks for oom kill with a tunable 
that (1) has a unit, (2) has a higher resolution, and (3) is linear and 
not exponential.  Memcg doesn't solve this issue without incurring a 1% 
memory cost.

> > higher resolution than the oom_adj scale from -16 to +15, and one that 
> > scales linearly as opposed to exponentially.  Since that tunable is much 
> > more powerful than the oom_adj implementation, which never made any real 
> 
> The reason that you ware NAKed was not to introduce new powerful feature.
> It was caused to break old and used feature from applications.
> 

No, it doesn't, and you completely and utterly failed to show a single 
usecase that broke as a result of this because nobody can currently use 
oom_adj for anything other than polarization.  Thus, there's no backwards 
compatibility issue.

> > sense for defining oom killing priority for any purpose other than 
> > polarization, the old tunable is deprecated for two years.
> 
> You haven't tested your patch at all. Distro's initram script are using
> oom_adj interface and latest kernel show pointless warnings 
> "/proc/xx/oom_adj is deprecated, please use /proc/xx/oom_score_adj instead."
> at _every_ boot time.
> 

Yes, I've tested it, and it deprecates the tunable as expected.  A single 
warning message serves the purpose well: let users know one time without 
being overly verbose that the tunable is deprecated and give them 
sufficient time (2 years) to start using the new tunable.  That's how 
deprecation is done.
