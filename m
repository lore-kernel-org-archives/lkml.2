Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab0KNVjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 16:39:35 -0500
Received: from smtp-out.google.com ([74.125.121.35]:17980 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab0KNVje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 16:39:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=kM8AqQNa00iuHOmzbQjCI9dTy2HUv5XiwOufXeIjGhIxSDgHSXtNblV4IJOq6LGUj2
         vV0ZFxSxLULZvWIPUlFQ==
Date: Sun, 14 Nov 2010 13:39:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH 2/4] Revert "oom: deprecate oom_adj tunable"
In-Reply-To: <20101114135323.E00D.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011141333330.22262@chino.kir.corp.google.com>
References: <20101109105801.BC30.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011091523370.26837@chino.kir.corp.google.com> <20101114135323.E00D.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Nov 2010, KOSAKI Motohiro wrote:

> No irrelevant. Your patch break their environment even though
> they don't use oom_adj explicitly. because their application are using it.
> 

The _only_ difference too oom_adj since the rewrite is that it is now 
mapped on a linear scale rather than an exponential scale.  That's because 
the heuristic itself has a defined range [0, 1000] that characterizes the 
memory usage of the application it is ranking.  To show any breakge, you 
would have to show how oom_adj values being used by applications are based 
on a calculated value that prioritizes those tasks amongst each other.  
With the exponential scale, that's nearly impossible because of the number 
of arbitrary heuristics that were used before oom_adj were considered 
(runtime, nice level, CAP_SYS_RAWIO, etc).

So don't talk about userspace breakage when you can't even describe it or 
present a single usecase.
