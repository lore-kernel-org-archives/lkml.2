Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab2BXRUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:20:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5330 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab2BXRUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:20:47 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=C9Pls-Yy-XAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=D19gQVrFAAAA:8 a=rzU8vT6vYBVgyffaZr4A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330104044.25686.165.camel@gandalf.stny.rr.com>
Subject: Re: Large slowdown with 'x86: Avoid invoking RCU when CPU is idle'
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Date: Fri, 24 Feb 2012 12:20:44 -0500
In-Reply-To: <20120224165130.GB2399@linux.vnet.ibm.com>
References: <20120222011652.GE23186@zod.bos.redhat.com>
	 <20120222013252.GZ2375@linux.vnet.ibm.com>
	 <20120222014242.GF23186@zod.bos.redhat.com>
	 <20120224144032.GA13903@zod.bos.redhat.com>
	 <20120224161743.GA2399@linux.vnet.ibm.com>
	 <20120224162745.GC13903@zod.bos.redhat.com>
	 <20120224165130.GB2399@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-24 at 08:51 -0800, Paul E. McKenney wrote:

> But after looking this over, Steven Rostedt's three-patch set should
> suffice:
> 
> 	https://lkml.org/lkml/2012/2/7/231
> 
> The reason that mine are not needed is that the problematic code is
> called -only- from idle, not from process context, and also that the
> problematic code is tracing.  My patch #45 is required for code that is
> called from both process context and from idle.  My patch #46 is required
> for non-tracing uses of RCU from within the idle loop -- along with TBD
> patches to wrap those uses of RCU in the RCU_NONIDLE() macro.
> 
> So again, in your particular case of x86's power-tracing features,
> Steven Rostedt's three-patch series called out above should be all
> that you need.
> 
> I have CCed Steven in case there is some prerequisite to his patch set.

The above link is the RFC, it probably still suffices, but the patches
that are going into mainline are here:

https://lkml.org/lkml/2012/2/13/530
https://lkml.org/lkml/2012/2/13/525
https://lkml.org/lkml/2012/2/13/524

The above is the order to apply them, (patch 3, 4, and 5) even though
they arrived to LKML out of order.

-- Steve


