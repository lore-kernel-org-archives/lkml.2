Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab1CJNCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:02:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47097 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab1CJNCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:02:44 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=XbqWoAS_rckA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=h_w0JG2fg3BU4W-zMnIA:9 a=OEuQTLSCGJ5iklzGwVEA:7 a=VGTCgwH-2PplIUnLymyIl4hbGdwA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional
 assignment of CC and AR"
From: Steven Rostedt <rostedt@goodmis.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com
In-Reply-To: <4D7873B5.7090602@linux.intel.com>
References: <1299715137-22768-1-git-send-email-dhsharp@google.com>
	 <1299715137-22768-3-git-send-email-dhsharp@google.com>
	 <4D7828F9.7000906@linux.intel.com>
	 <1299720997.15854.276.camel@gandalf.stny.rr.com>
	 <4D783038.8080103@linux.intel.com>
	 <AANLkTikHy1pZP0=cpmSD_HG-jeJvgne3u2ivOif6DHP8@mail.gmail.com>
	 <1299725486.15854.281.camel@gandalf.stny.rr.com>
	 <1299727594.15854.310.camel@gandalf.stny.rr.com>
	 <AANLkTi=WRv2PekEyuEh5k9VOv9LmGCWa6KxXn0BeZVSk@mail.gmail.com>
	 <4D7873B5.7090602@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 08:02:42 -0500
Message-ID: <1299762162.15854.326.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 22:46 -0800, Darren Hart wrote:

> > This seems to do it all:
> >
> > define allow-override
> >    $(if $(or $(findstring environment,$(origin $(1))),
> >              $(findstring command line,$(origin $(1)))),,\
> >      $(eval $(1) = $(2)))
> > endef
> >
> > $(call allow-override,CC,$(CROSS_COMPILE)gcc)
> > $(call allow-override,AR,$(CROSS_COMPILE)ar)
> 
> Egads .... that's hideous :-) This level of complexity makes it very 
> difficult for people to readily understand it. What does this offer over:

Love the world of makefiles ;) Nothing that comments wont solve.

> 
> ifdef CROSS_COMPILE
> CC = $(CROSS_COMPILE)gcc
> AR = $(CROSS_COMPILE)ar
> endif
> 
> besides being 3 lines longer with much more complex Makefile syntax and 
> conditional statements?

Yes, the above is simple and solves the issue for both you and David,
but it has a side-effect that David already pointed out. CC is now cc
and not gcc. I don't like that, as I do have systems that cc is
different that gcc and I want to use gcc.

But if I define CROSS_COMPILE it then suddenly uses gcc. Yes this may
not seem like a big deal now, but in the future, it could cause a lot of
headache. I rather have the more complex yet correct solution that is
consistent than a simple easy to read solution with a subtle side-effect
that is hidden.

-- Steve


