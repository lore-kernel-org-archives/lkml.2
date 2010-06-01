Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab0FARUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 13:20:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:40477 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab0FARUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 13:20:33 -0400
Subject: Re: [PATCH 2/4] sched: adjust when cpu_active and cpuset
 configurations are updated during cpu on/offlining
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       paulus@samba.org, acme@redhat.com, Paul Menage <menage@google.com>
In-Reply-To: <4C053C39.9070405@kernel.org>
References: <1275332199-28082-1-git-send-email-tj@kernel.org>
	 <1275332199-28082-3-git-send-email-tj@kernel.org>
	 <1275407846.27810.27627.camel@twins>  <4C053C39.9070405@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 01 Jun 2010 19:20:35 +0200
Message-ID: <1275412835.27810.27887.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 18:58 +0200, Tejun Heo wrote:
> Hello,
> 
> On 06/01/2010 05:57 PM, Peter Zijlstra wrote:
> > I know we all love notifier lists, but doesn't the below code get lots
> > more readable if we don't play tricks with notifier priorities and
> > simply hardcode the few (perf/sched/cpuset) callbacks into the hotplug
> > paths?
> 
> Maybe, maybe not.  In this case, I kind of like that sleep failure
> case doesn't have to be explicitly rolled back but if you like hard
> coding that's fine too.

Hurm, yeah that rollback might make things messy indeed.

> > Also, I'm afraid you've now inverted the relation between
> > cpu_active_mask and parition_sched_domains().
> >
> > You need to first set/clear the active mask, then rebuild the domain.
> > But with your patch parition_sched_domains() gets called in the regular
> > DOWN_PREPARE path, while we only clear active at the very end, which
> > means we build the wrong domains.
> 
> Ah, right forgot about that.  So, the things that need to be ordered
> are cpu_active mask update, cpuset configuration and sched domains,
> right?

Right, I think that should cover it.
