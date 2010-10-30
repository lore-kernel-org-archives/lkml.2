Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab0J3B12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 21:27:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43512 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab0J3B10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 21:27:26 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=jaF2b-Ib8NwA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=DAJIHWo6YThM6G2F_RMA:9 a=3dGRKDUZa0E31aidkvLWn9_rpr8A:4 a=PUjeQqilurYA:10 a=hXFNqW0bEOwA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/5] [PATCH 1/5] kconfig: Make localmodconfig handle
 environment variables
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <AANLkTi=a8dp-WUNHAkx2fZ5GgNHmDw+ee7MDeUSL44Z0@mail.gmail.com>
References: <20101029054310.790179545@goodmis.org>
	 <20101029054423.498608001@goodmis.org>
	 <AANLkTi=a8dp-WUNHAkx2fZ5GgNHmDw+ee7MDeUSL44Z0@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Oct 2010 21:27:22 -0400
Message-ID: <1288402042.29632.50.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 20:26 -0400, Arnaud Lacombe wrote:
> Hi,

> Technically, it is _not_ an environment variable; it is a kconfig
> symbol's name. In this particular case, both name collide and the
> kconfig symbol happens to get its default value from the environment.
> The real fixes, from my point of view, would be to have a perl binding
> of the kconfig backend and get rid of read_kconfig(). That said, your
> patch is broken if a symbol happen not to match an environment
> variable (both in name and value).

That sounds like a proper fix. Unfortunately, I don't have the time to
work on this now, and although this fix works by coincidence, it
never-the-less works, as suppose to just having localmodconfig crash.

But you are right. After KS and Plumbers, I'll work on doing something
like that. That can probably solve some of the other issues I'm having
(still keeping too many modules enabled).

> 
> Btw, two questions:
>  - who has authority on kconfig ? Michal or you ? MAINTAINERS say
> "Roman Zippel", but AFAIK, this is no longer valid.

Michal is in charge of the build system. I just wrote
streamline_config.pl, and have been maintaining it on my own. If I ever
need to touch anything outside of that script, I always ask for Michal's
Acked-by.

>  - what is the delay someone in CC: is given the time to answer a
> patch ? I see that this one particularly is already in Linus' tree.

Well, again, I consider myself the maintainer of streamline_config.pl,
and as long as my changes don't affect anything else, I don't ask for
forgiveness ;-)

I probably should rename my subject (and my git tree) to
s/kconfig/localmodconfig/. But then again, having the kconfig: name gets
the attention of people like yourself to tell me what you told me.

-- Steve



