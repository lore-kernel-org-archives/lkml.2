Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab1EQOUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:20:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53042 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1EQOUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:20:13 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=TEquWTb0WnsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=UEB_33vsKOmkoOvMntAA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 2/2] ftrace/kbuild: Add recordmcount files to
 force full build
From: Steven Rostedt <rostedt@goodmis.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1305640042.5456.727.camel@gandalf.stny.rr.com>
References: <20110517021027.390391519@goodmis.org>
	 <20110517021423.661004726@goodmis.org>
	 <20110517133646.GP13293@sepie.suse.cz>
	 <1305640042.5456.727.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 May 2011 10:20:10 -0400
Message-ID: <1305642010.5456.730.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 09:47 -0400, Steven Rostedt wrote:
> On Tue, 2011-05-17 at 15:36 +0200, Michal Marek wrote:
> 
> > We could add recordmcount.c as a dependency in scripts/Makefile.build
> > directly, without playing with fixdep, like this (untested):
> 
> I actually tried this first, and it didn't seem to work. I'll go ahead
> and give it another try (maybe I did something wrong). But I do prefer
> this over my fixdep change.
> 
> Thanks, I'll let you know the outcome.

Awesome! This worked. I wonder what screw up I did to keep mine from
working? Anyway, I made a single change to your patch:

-recordmcount_source := $(srctree)/scripts/recordmcount.c
+recordmcount_source := $(srctree)/scripts/recordmcount.c \
+                   $(srctree)/scripts/recordmcount.h


Could you send me your Signed-off-by, and I'll add this to the beginning
of my patch queue.

Thanks!

-- Steve


