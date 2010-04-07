Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0DGMHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:07:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:62084 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923Ab0DGMHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:07:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EZW9wHSqjT+yxnkQ9Pb1FQsqBYmR61npvl7CqN5NHjRIojwkRugn5ZogHm5MF9bJbM
         nGV5LYhqhgzZvnm5UPpoAHWxpcW8fyIkXvKCgQJOXVBp9IgsMCdVDM/ctccvd7Cq9mc0
         RzUIWJYMPzR3pIAOK9ExQqQU/WurHkTChL0XU=
Date: Wed, 7 Apr 2010 14:06:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf: Store active software events in a hashlist
Message-ID: <20100407120653.GF5143@nowhere>
References: <1270476502-6214-1-git-send-regression-fweisbec@gmail.com> <1270567653.20295.11.camel@laptop> <20100407115624.GD5143@nowhere> <1270641500.20295.807.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270641500.20295.807.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 01:58:20PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-04-07 at 13:56 +0200, Frederic Weisbecker wrote:
> > 
> > > 
> > > So looks good, altough I think we want to do that online/hotplug thing.
> > 
> > 
> > That would let us allocate on online cpus instead of possibles? Yeah right.
> 
> Right, so if you want to go this route (and not simply embed it in the
> percpu data), the complication I thought of is that you want the
> refcount on offline cpus but not the allocation, since its very hard to
> reconstruct the number of events that had event->cpu == -1.


Ok, right I can do that.

