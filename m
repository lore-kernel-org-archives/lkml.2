Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab0LJLTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 06:19:06 -0500
Received: from www.tglx.de ([62.245.132.106]:57923 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab0LJLTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 06:19:04 -0500
Date: Fri, 10 Dec 2010 12:18:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, eric.dumazet@gmail.com, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, penberg@kernel.org
Subject: Re: [PATCH 07/16] x86: Remove custom apic->cpu_to_logical_apicid()
 implementations
In-Reply-To: <4D020B22.1030701@kernel.org>
Message-ID: <alpine.LFD.2.00.1012101215550.2653@localhost6.localdomain6>
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-8-git-send-email-tj@kernel.org> <alpine.LFD.2.00.1012092217000.2653@localhost6.localdomain6> <4D020B22.1030701@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010, Tejun Heo wrote:

> Hello, Thomas.
> 
> On 12/09/2010 10:28 PM, Thomas Gleixner wrote:
> >> After the previous patch, apic->cpu_to_logical_apicid() is no longer
> >> used.  The callback will be repurposed.  Remove all the custom
> > 
> > That's a very bad idea. You remove the callbacks from the esoteric
> > platforms, but you keep the other implementation in the tree.
> >
> > It's not longer used now, so remove all incarnations and get rid of
> > all those useless = NULL initializations at the same time. Then
> > implement a new callback with a different name.
> 
> Yeah, that would be cleaner.  I wasn't very sure about clearing
> unimplemented apic ops.  Currently the rule seems to be always setting
> them to NULL and I didn't want to re-do that with a new callback.
> 
> > It's slightly more work and code churn, but it makes the change
> > entirely clear. It'd be also nice to annotate in the function name
> > that this is 32bit only or even make it 32bit dependent if it's not
> > too much ifdeffery
> 
> Yeah, sure, if the silly NULL assignments aren't necessary, I don't
> think it would be much more churn anyway.

I don't see much point in them, as static struct initializing fills
all unset members with zero anyway. And we have no way to check with
the compiler that every instance has really initialized all members,
which would make sense to ensure that people look at all instances
when they add new members.

Thanks,

	tglx
