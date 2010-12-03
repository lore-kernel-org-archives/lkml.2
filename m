Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0LCVaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 16:30:35 -0500
Received: from canuck.infradead.org ([134.117.69.58]:43862 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab0LCVae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:30:34 -0500
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
In-Reply-To: <4CF9368C.8030309@redhat.com>
References: <20101202144129.4357fe00@annuminas.surriel.com>
	 <20101202144423.3ad1908d@annuminas.surriel.com>
	 <20101203005008.GU10050@sequoia.sous-sol.org> <4CF9368C.8030309@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Dec 2010 22:30:42 +0100
Message-ID: <1291411842.2032.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 13:27 -0500, Rik van Riel wrote:
> > Should these details all be in sched_fair?  Seems like the wrong layer
> > here.  And would that condition go the other way?  If new vruntime is
> > smaller than min, then it becomes new cfs_rq->min_vruntime?
> 
> That would be nice.  Unfortunately, EXPORT_SYMBOL() does
> not seem to work right from sched_fair.c, which is included
> from sched.c instead of being built from the makefile!

I'm not quite sure why that is, but I kinda like that, the policy
implementation should never export stuff.

Code outside the scheduler cannot ever know the policy of a task, hence
policy specific exports are bad.

A generic export with policy implementations (like the
sched_class::yield_to() proposal) are the proper way.
