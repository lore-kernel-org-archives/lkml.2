Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab1FPQZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:25:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab1FPQZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:25:10 -0400
Date: Thu, 16 Jun 2011 18:22:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Greg Kurz <gkurz@fr.ibm.com>,
        linux-kernel@vger.kernel.org, containers@lists.osdl.org,
        akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was
	Vpid:)
Message-ID: <20110616162220.GB3189@redhat.com>
References: <20110615145527.4016.70157.stgit@bahia.local> <20110615190302.GA16440@redhat.com> <1308223158.8230.66.camel@bahia.local> <4DF9F657.7030605@fr.ibm.com> <20110616130613.GC19312@redhat.com> <4DFA126D.9060102@fr.ibm.com> <m1fwn9by3e.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fwn9by3e.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16, Eric W. Biederman wrote:
>
> I remember there were a few very weird things with pids when ptracing
> a process in another pid namespace.

The only problems is pids. PTRACE_EVENT_FORK/etc reports the global pid.
This is fixable. Some tracers look at syscall_get_return_value() register
and get the "local" pid which they do not want.

> It may be that ActivePid is enough
> to allow the tracer to figure out the confusing information it is
> getting.

I don't think so. ActivePid doesn't help unless you know all pids in
this container.

> I would be surprised if using ptrace to send signals is how you
> want to do things.

Yes, yes, this is hack.

Oleg.

