Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1EDQGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:06:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49202 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab1EDQGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:06:14 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=Not3D1qn5yUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Jm7J0sRII75vpojbQ-YA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is
 and how it works.
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Paris <eparis@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Will Drewry <wad@chromium.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, agl@chromium.org, jmorris@namei.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1304524465.10692.21.camel@localhost.localdomain>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	 <1303960136-14298-4-git-send-email-wad@chromium.org>
	 <20110428070636.GC952@elte.hu>
	 <1304002571.2101.38.camel@localhost.localdomain>
	 <BANLkTi=5NYTM5T2LthVL+8kjQvYWwHSVPg@mail.gmail.com>
	 <20110429131845.GA1768@nowhere>
	 <BANLkTimhWZURqgAXG45=3CG-bNhv+g-Ftg@mail.gmail.com>
	 <20110503012857.GA8399@nowhere>
	 <BANLkTimhugGCnMQ4f2T2HOvwVLrGTREPkg@mail.gmail.com>
	 <1304511396.25414.2422.camel@gandalf.stny.rr.com>
	 <1304524465.10692.21.camel@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 04 May 2011 12:06:09 -0400
Message-ID: <1304525169.25414.2427.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 11:54 -0400, Eric Paris wrote:

> As this is a deny by default interface which only allows you to further
> restrict you couldn't add more than 1 syscall if you didn't have an
> explict 'apply' action.
> 
> SECCOMP_FILTER_SET, __NR_fo, "a=0"
> SECCOMP_FILTER_SET, __NR_read, "1" == EPERM
> 
> Maybe apply on set is fine after the first apply, but we definitely need
> some way to do more than 1 set before the rules are applied....

So we could have SET be 'or' and APPLY be 'and'.

SECCOMP_FILTER_SET, __NR_foo, "a=0"
SECCOMP_FILTER_SET, __NR_read, "1" == EPERM
SECCOPM_FILTER_APPLY

SECCOMP_FILTER_SET, __NR_foo, "b=0"
SECCOPM_FILTER_APPLY

Will end up being:

(foo: a == 0 || read: "1" == EPERM) && (foo: b == 0)

The second set/apply now removes the read option, and foo only works if
a is 0 and b is 0.

This would also work for children, as they can only restrict (with
'and') and can not add more control.

-- Steve


