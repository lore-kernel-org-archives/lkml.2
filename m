Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab0IUPOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:14:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56163 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab0IUPON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:14:13 -0400
X-Authority-Analysis: v=1.1 cv=QPMnOuvfoRK4nyqTv0NRvva4Xk0fUUuJArrqv1I9dZo= c=1 sm=0 a=EgsJD7j8BzoA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=AarIoXAkcPmwHLwPV2oA:9 a=u9fQmqDAvJlQhgjIEokA:7 a=PdwsKtjE5jzBLebDH6NbWl-AVrYA:4 a=PUjeQqilurYA:10 a=qaB9cW9uIVSuaon0:21 a=D6cg33BtPCCz38qM:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 03/10] jump label v11: base patch
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com
In-Reply-To: <0e1f6b339e72a449fed0df7b801da607.squirrel@www.firstfloor.org>
References: <cover.1284733808.git.jbaron@redhat.com>
	 <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com>
	 <20100921131232.GA3024@one.firstfloor.org>
	 <20100921143555.GA2873@redhat.com>
	 <0e1f6b339e72a449fed0df7b801da607.squirrel@www.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 21 Sep 2010 11:14:09 -0400
Message-ID: <1285082049.23122.1930.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 16:41 +0200, Andi Kleen wrote:
> >
> > So there are ~150 tracepoints, but this code is also being proposed for
> > use with 'dynamic debug' of which there are > 1000, and I'm hoping for
> > more users moving forward.
> 
> Even 1000 is fine to walk, but if it was sorted a binary search
> would be much faster anyways. That is then you would still
> need to search for each module, but that is a relatively small
> number (< 100)

xfs has > 100 tracepoints

> 
> > Also, I think the hash table deals nicely with modules.
> 
> Maybe but it's also a lot of code. And it seems to me
> that it is optimizing the wrong thing. Simpler is nicer.

I guess simplicity is in the eye of the beholder. I find hashes easier
to deal with than binary searching sorted lists. Every time you add a
tracepoint, you need to resort the list.

Hashes are much easier to deal with and scale nicely. I don't think
there's enough rational to switch this to a binary list.

-- Steve


