Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab2INRQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:16:56 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:38691 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2INRQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:16:54 -0400
Date: Fri, 14 Sep 2012 22:42:19 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] uprobes: teach uprobes to clear MMF_HAS_UPROBES
Message-ID: <20120914171219.GG28033@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120819164008.GA25454@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120819164008.GA25454@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12091417-3864-0000-0000-000004A203D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-08-19 18:40:08]:

> Hello.
> 
> On top of "kill uprobes_state->count, add MMF_HAS_UPROBES"
> series.
> 
> Once again, I am not sure we really need this (except 1/3).
> Perhaps we could remove uprobe_munmap() instead and forget
> about the false-positive MMF_HAS_UPROBES's.
> 
> OTOH, imho it looks a bit more clean this way. Please comment.


I am agree with the current approach.

The other approach could be to forget about MMF_RECALC_UPROBES and
uprobe_munmap() (essentially patch 2). But in patch 3 we will end up
calling mmf_recalc_uprobes() everytime a process with MM_HAS_UPROBES
hits a non-uprobe breakpoint.


> 
> diffstat reports the code bloat, but note that the previous
> series removed more code.
> 
> Oleg.
> 
>  include/linux/sched.h   |    3 +-
>  kernel/events/uprobes.c |   82 +++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 67 insertions(+), 18 deletions(-)
> 

