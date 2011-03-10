Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab1CJCva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 21:51:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59350 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1CJCv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 21:51:28 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=XbqWoAS_rckA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=QyXUC8HyAAAA:8 a=2nUukt864RZjTy-CnCoA:9 a=UW2HUVtincxO0kw8aCCntSNQJRcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional
 assignment of CC and AR"
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: Darren Hart <dvhart@linux.intel.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com
In-Reply-To: <AANLkTikHy1pZP0=cpmSD_HG-jeJvgne3u2ivOif6DHP8@mail.gmail.com>
References: <1299715137-22768-1-git-send-email-dhsharp@google.com>
	 <1299715137-22768-3-git-send-email-dhsharp@google.com>
	 <4D7828F9.7000906@linux.intel.com>
	 <1299720997.15854.276.camel@gandalf.stny.rr.com>
	 <4D783038.8080103@linux.intel.com>
	 <AANLkTikHy1pZP0=cpmSD_HG-jeJvgne3u2ivOif6DHP8@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 09 Mar 2011 21:51:26 -0500
Message-ID: <1299725486.15854.281.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 18:27 -0800, David Sharp wrote:
> On Wed, Mar 9, 2011 at 5:58 PM, Darren Hart <dvhart@linux.intel.com> wrote:

> > dvhart@doubt:templates$ cat Makefile
> > ifdef CROSS_COMPILE
> > CC = $(CROSS_COMPILE)gcc
> > AR = $(CROSS_COMPILE)ar
> > endif
> >
> > all:
> >        echo "CC: $(CC)"
> >
> > dvhart@doubt:templates$ make -s
> > CC: cc
> >
> > dvhart@doubt:templates$ CC=gcc-4.5.1 make -s
> > CC: gcc-4.5.1
> >
> > dvhart@doubt:templates$ CROSS_COMPILE=my-cross- make -s
> > CC: my-cross-gcc
> >
> >
> > Seems to meet everyone's needs without changing any tools/scripts/etc that
> > have used trace-cmd before or after the CC ?= wreckage.
> 
> It's a little odd that the default CC is "cc" unless you supply
> CROSS_COMPILE, then it's "gcc". I'd probably be okay with this, but I
> would think it's weird.
> 
> I don't know the answers, but if we take the kernel Makefile as a
> template, then setting CC doesn't work.
> 

I really don't care much for this either. But I'm trying to make it work
for everyone. Honestly, I think the BUILD_CC version is the cleanest,
but I understand that this will add a burden onto Darren to fix his
tools to handle it, whereas, I would like to avoid that.

I'll play with some other make tricks and see if I can come up with a
better solution.

-- Steve


