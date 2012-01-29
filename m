Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab2A2Rv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 12:51:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab2A2RvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 12:51:25 -0500
Date: Sun, 29 Jan 2012 19:50:57 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Steets <asteets@rgmadvisors.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: prctl(PR_TASK_PERF_EVENTS_DISABLE) has no effect
Message-ID: <20120129175057.GC2938@redhat.com>
References: <4F22D8D9.3010108@rgmadvisors.com>
 <20120128120151.GA10390@elte.hu>
 <4F248938.5030507@rgmadvisors.com>
 <20120129163235.GB23408@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120129163235.GB23408@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 05:32:35PM +0100, Ingo Molnar wrote:
> 
> * Andrew Steets <asteets@rgmadvisors.com> wrote:
> 
> > On 1/28/12 6:01 AM, Ingo Molnar wrote:
> > 
> > >> prctl(PR_TASK_PERF_EVENTS_DISABLE) doesn't appear to 
> > >> disable perf event counters.  Here is a demonstration 
> > >> program:
> > >
> > > btw., what's your usecase?
> > 
> > I'm trying to profile a small section of a long-running 
> > program.  I ran into trouble using call-graph recording and I 
> > thought this might be an alternative way of getting what I was 
> > after.
> 
> That usecase indeed makes sense. Peter, could we allow this for 
> privileged tasks, depending on the perf_paranoia settings or 
> such?
> 
This sounds useful not only for privileged tasks. Why not make
it event attribute? If user wants PR_TASK_PERF_EVENTS_DISABLE be
respected for an event it can specify special argument like:

perf record -e cycles:n ./a.out

--
			Gleb.
