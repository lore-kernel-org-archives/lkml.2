Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab0JZTiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:38:13 -0400
Received: from smtp-out.google.com ([74.125.121.35]:35974 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0JZTiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:38:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=sw2UI0DADHpOOa2hw3YrtqD+1QCDDQFNWQLKdg6xW1Q3kahbYr0A0S0gy+lScIyMn0
         28+RdJ3/P5iIvtbzofFg==
Date: Tue, 26 Oct 2010 12:37:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH 2/4] Revert "oom: deprecate oom_adj tunable"
In-Reply-To: <20101026220237.B7DA.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1010261234230.5578@chino.kir.corp.google.com>
References: <20101025122723.916D.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1010251338081.21737@chino.kir.corp.google.com> <20101026220237.B7DA.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, KOSAKI Motohiro wrote:

> > NACK as a logical follow-up to my NACK for "oom: remove totalpage 
> > normalization from oom_badness()"
> 
> Huh?
> 
> I requested you show us justification. BUT YOU DIDNT. If you have any 
> usecase, show us RIGHT NOW. 
> 

The new tunable added in 2.6.36, /proc/pid/oom_score_adj, is necessary for 
the units that the badness score now uses.  We need a tunable with a much 
higher resolution than the oom_adj scale from -16 to +15, and one that 
scales linearly as opposed to exponentially.  Since that tunable is much 
more powerful than the oom_adj implementation, which never made any real 
sense for defining oom killing priority for any purpose other than 
polarization, the old tunable is deprecated for two years.
