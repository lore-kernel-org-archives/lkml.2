Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227Ab1FXCAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 22:00:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41303 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1FXCAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 22:00:04 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=n8OuPOP5gMEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=eP2w8RFJMYaamG6b9ZwA:9 a=4SrUwmsTrvRdyjUPlPIA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 09/15] xen/trace: add tlb flush tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <4E03C510.5050801@goop.org>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
	 <4db3e32a6b21efdb4d82646816ddb1bb82ff2259.1308607697.git.jeremy.fitzhardinge@citrix.com>
	 <20110621140705.GD28229@dumpdata.com>  <4E03996B.9050904@goop.org>
	 <1308860628.531.42.camel@gandalf.stny.rr.com>  <4E03C510.5050801@goop.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 23 Jun 2011 22:00:01 -0400
Message-ID: <1308880801.531.54.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 15:58 -0700, Jeremy Fitzhardinge wrote:

> > If you really need something like this, maybe I'll add a
> > DEFINE_EVENT_NOARGS() that will not require arguments and can eliminate
> > a lot of code that TRACE_EVENT() adds.
> 
> If you like, but only if you think its worth the effort.  The empty
> string thing is a bit of an ugly hack, but its not like it makes a mess
> everywhere.

The problem I have is not the ugliness, but more of the wasted code that
is generated to do nothing. The TRACE_EVENT() generates lots of helper
functions that are unique to handle different events. The fact that we
have no args is generating code that does a lot of nothing. Every
TRACE_EVENT() can create 5k of code/data. This is why I advocate the
DEFINE_TRACE_CLASS() and DEFINE_EVENT() because it reuses a lot of the
code.

If we had a NOARGS event that was just a marker, then we could eliminate
most of the helper functions for these kinds of trace points.

-- Steve


