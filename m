Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab1E1Dir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 23:38:47 -0400
Received: from jaguar.mail.utk.edu ([160.36.0.84]:34404 "EHLO
	jaguar.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab1E1Diq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 23:38:46 -0400
Date: Fri, 27 May 2011 23:38:30 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        acme@redhat.com
Subject: Re: perf: regression with PERF_EVENT_IOC_REFRESH
In-Reply-To: <1306233036.2497.15.camel@laptop>
Message-ID: <alpine.DEB.2.00.1105272332400.9313@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>  <1306182141.2497.5.camel@laptop>  <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu> <1306233036.2497.15.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Peter Zijlstra wrote:
> 
> This is very clear abuse of the API and I'm not really inclined to fix
> it, in fact, I'd be tempted to add an additional test to verify the
> argument to REFRESH > 0.

on that note (and while trying to document exactly what the ioctls do) it 
seems that a PERF_EVENT_IOC_REFRESH with an argument of anything higher 
than one does not work on kernels 2.6.36 and newer.  The behavior acts
as if 1 was passed, even if you pass in, say, 3.

Is it worth bisecting this, or has this become the new official behavior 
since no one noticed until now?

To reproduce you can grab my tests from here:
   http://web.eecs.utk.edu/~vweaver1/projects/perf-events/validation.html

and run the
    ./validation/simple_overflow_leader
test

Vince

