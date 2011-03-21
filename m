Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1CUN0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 09:26:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53455 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab1CUN0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 09:26:22 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=d6KjmF4z1lEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=rH27BpueG1JZCgsVSrYA:9 a=wxfaz59aih7Yp_dp2HcA:7 a=SWBXNnDfrf-1nl0dJH2t5oPw0gUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110319193954.GA2032@redhat.com>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
	 <20110317211548.646b04d2@tpl.lwn.net>  <20110319193954.GA2032@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 21 Mar 2011 09:26:20 -0400
Message-ID: <1300713980.16880.5813.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-19 at 15:39 -0400, Dave Jones wrote:

> Something that has crossed my mind over the last few days was the idea
> of splitting checkpatch into two tools.
> One for checking CodingStyle issues, and one for checking for actual
> code problems like the memset example.
> 
> The motivation for such is that I think it's pretty clear that many maintainers
> never run checkpatch on patches they queue up before pushing to Linus...
> 
> $ scripts/checkpatch.pl  ~/Mail/upstream/2.6.39/head-March-18-2011 | wc -l
> 2361
> 

I run it on all my patches. But there are some warnings that I ignore.
Sometimes I don't split the 80char lines if doing so makes the code even
uglier.


> The bulk of this is all "missing space here" "don't put a space there" type
> fluff that most maintainers just don't care about.  Any valuable warnings
> are lost in the noise.  If we had a separate tool to check for real flaws,
> (or even a way to suppress the stylistic warnings from the existing one)
> maybe more maintainers would run their changes through it.

As I replied with my phone, having a suppress warnings would be nice.

checkpatch -e patch

where -e is errors only?

> 
> I dunno, maybe I'm just a crazy dreamer too, but I think many people
> have written checkpatch off as useless in its current incarnation.

Well I and I'm sure Ingo use it quite a bit. I'm sure there are others
that do too.

I would really like to disable warnings, as the patches to my magic
macros break all sorts of checkpatch formatting rules, but real errors
may still exist. And because of that, I seldom use checkpatch on patches
that modify those macros.

Note, I've even found myself running checkpatch on non Linux code too ;)

-- Steve


