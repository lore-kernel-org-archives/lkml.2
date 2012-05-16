Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407Ab2EPTry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:47:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21716 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964985Ab2EPTrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:47:46 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=XlIr_nCh6zIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=W8j2aq1Z49zx_hoCm0sA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337197665.6724.73.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH] tracing: Remove useless 4 bytes of padding from
 every event
From: Steven Rostedt <rostedt@goodmis.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 16 May 2012 15:47:45 -0400
In-Reply-To: <4FB401B2.1010906@linux.intel.com>
References: <1337175871.6724.46.camel@gandalf.stny.rr.com>
	 <CA+55aFzVngkixn-t0mK8QqgnPhCzN2AsUtzfZ3BkLiJAcjNOzQ@mail.gmail.com>
	 <4FB401B2.1010906@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Fixes David Sharps email. I have two versions, and picked the broken 
  one :-p ]


On Wed, 2012-05-16 at 12:36 -0700, Arjan van de Ven wrote:
> On 5/16/2012 12:33 PM, Linus Torvalds wrote:
> > On Wed, May 16, 2012 at 6:44 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >>
> >> But this change will break PowerTop v1. Thus my question is, how long do
> >> we need to keep this wasted space in the ring buffers to satisfy an out
> >> of date tool?
> > 
> > The wasted space seems of limited importance.

Depends on who you ask. For you, it's probably of no importance. For
someone trying to get as many events as possible, it's of much greater
importance. Lack of events in a report is one of the biggest issues we
have. Especially for those that are trying to debug an issue and needs
as much info as possible. (function tracing sucks up a hell of a lot)

But that said, it doesn't go against what you stated. "limited
importance". Its importance is limited to a group of people.

> > 
> > More important is to check which distros have the new powertop.
> > 
> > F16 and F17 seem to have powertop-1.98, which I assume is the new
> > world order already. But maybe I assume incorrectly.
> 
> this is the one that will break

Shh ;-)

> 
> > 
> > F14 (which I personally still use, since it doesn't have gnome3) is 1.13.
> 
> this one is fine, it does not use perf events at all.

Oo oo! We can change it and Linus won't know.

-- Steve


