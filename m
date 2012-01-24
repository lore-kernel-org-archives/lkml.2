Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2AXB1C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 20:27:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42453 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab2AXB0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 20:26:49 -0500
Date: Tue, 24 Jan 2012 02:26:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 3/8] ftrace: Add enable/disable ftrace_ops control
 interface
Message-ID: <20120124012639.GC15643@somewhere.redhat.com>
References: <1323105776-26961-1-git-send-email-jolsa@redhat.com>
 <1324468136-3997-1-git-send-email-jolsa@redhat.com>
 <1324468136-3997-4-git-send-email-jolsa@redhat.com>
 <1324483293.5916.89.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324483293.5916.89.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 11:01:33AM -0500, Steven Rostedt wrote:
> On Wed, 2011-12-21 at 12:48 +0100, Jiri Olsa wrote:
> > +static int control_ops_is_disabled(struct ftrace_ops *ops)
> > +{
> > +	atomic_t *disabled = this_cpu_ptr(ops->disabled);
> 
> Again, the use of "this_cpu_ptr" is wrong. Gah! We should nuke all of
> that crap.
> 

Is it? It includes the preemption check if CONFIG_DEBUG_PREEMPT, just
like __get_cpu_var()

Just saying that because in a later version of this patch, Jiri used
per_cpu_ptr(ops->disabled, cpu). And this is the wrong thing to do
given that we always fetch the local pointer and per_cpu_ptr() doesn't
check for preemption disabled.

 
> > +	return atomic_read(disabled);
> > +}

