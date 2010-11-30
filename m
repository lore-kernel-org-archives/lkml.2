Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab0K3UCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:02:47 -0500
Received: from smtp-out.google.com ([74.125.121.35]:5305 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab0K3UCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:02:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=kiiQH0N9IlwaoEidCG2f/nVjintrDzE0MhAjao4NsvcvFY/RsoV/0K4cCEY3bYQXmj
         mCg9gq5bt+Q2TOzyfk8g==
Date: Tue, 30 Nov 2010 12:02:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>,
        Bodo Eggert <7eggert@web.de>, Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
In-Reply-To: <20101130220510.832E.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011301201060.12979@chino.kir.corp.google.com>
References: <20101123151731.7B7B.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011271743180.3764@chino.kir.corp.google.com> <20101130220510.832E.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, KOSAKI Motohiro wrote:

> > > > You may remember that the initial version of my rewrite replaced oom_adj 
> > > > entirely with the new oom_score_adj semantics.  Others suggested that it 
> > > > be seperated into a new tunable and the old tunable deprecated for a 
> > > > lengthy period of time.  I accepted that criticism and understood the 
> > > > drawbacks of replacing the tunable immediately and followed those 
> > > > suggestions.  I disagree with you that the deprecation of oom_adj for a 
> > > > period of two years is as dramatic as you imply and I disagree that users 
> > > > are experiencing problems with the linear scale that it now operates on 
> > > > versus the old exponential scale.
> > > 
> > > Yes and No. People wanted to separate AND don't break old one.
> > > 
> > 
> > You're arguing on the behalf of applications that don't exist.
> 
> Why?
> You actually got the bug report.
> 

There have never been any bug reports related to applications using 
oom_score_adj and being impacted with its linear mapping onto oom_adj's 
exponential scale.  That's because no users prior to the rewrite were 
using oom_adj scores that were based on either the expected memory usage 
of the application nor the capacity of the machine.
