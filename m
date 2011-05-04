Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab1EDMQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 08:16:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37621 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab1EDMQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 08:16:41 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=Not3D1qn5yUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=o0-83b1B9SIW2OcrnA4A:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is
 and how it works.
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Will Drewry <wad@chromium.org>, Eric Paris <eparis@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, agl@chromium.org, jmorris@namei.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <BANLkTimhugGCnMQ4f2T2HOvwVLrGTREPkg@mail.gmail.com>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	 <1303960136-14298-4-git-send-email-wad@chromium.org>
	 <20110428070636.GC952@elte.hu>
	 <1304002571.2101.38.camel@localhost.localdomain>
	 <BANLkTi=5NYTM5T2LthVL+8kjQvYWwHSVPg@mail.gmail.com>
	 <20110429131845.GA1768@nowhere>
	 <BANLkTimhWZURqgAXG45=3CG-bNhv+g-Ftg@mail.gmail.com>
	 <20110503012857.GA8399@nowhere>
	 <BANLkTimhugGCnMQ4f2T2HOvwVLrGTREPkg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 04 May 2011 08:16:36 -0400
Message-ID: <1304511396.25414.2422.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 03:47 +0200, Frederic Weisbecker wrote:
> 2011/5/3 Frederic Weisbecker <fweisbec@gmail.com>:

> Even better: applying a filter would always automatically be an
> intersection of the previous one.
> 
> If you do:
> 
> SECCOMP_FILTER_SET, __NR_foo, "a == 1 || a == 2"
> SECCOMP_FILTER_APPLY
> SECCOMP_FILTER_SET, __NR_foo, "b == 2"
> SECCOMP_FILTER_APPLY
> SECCOMP_FILTER_SET, __NR_foo, "c == 3"
> SECCOMP_FILTER_APPLY
> 
> The end result is:
> 
> "(a == 1 || a == 2) && b == 2  && c == 3"
> 

I'm a little confused. Why do we have both a FILTER_SET and a
FILTER_APPLY? Maybe this was discussed earlier in the thread and I
missed it or simply forgot.

Why not just apply on the set call?

-- Steve


