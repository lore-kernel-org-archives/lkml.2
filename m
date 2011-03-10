Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1CJNHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:07:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40214 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab1CJNHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:07:45 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=XbqWoAS_rckA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=cHa24kVuPC_Gx4GcXocA:9 a=5L5Qiv4pIAKaryHzdUlK2WCNQNsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional
 assignment of CC and AR"
From: Steven Rostedt <rostedt@goodmis.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com
In-Reply-To: <4D787294.4040906@linux.intel.com>
References: <1299715137-22768-1-git-send-email-dhsharp@google.com>
	 <1299715137-22768-3-git-send-email-dhsharp@google.com>
	 <4D7828F9.7000906@linux.intel.com>
	 <1299720997.15854.276.camel@gandalf.stny.rr.com>
	 <4D783038.8080103@linux.intel.com>
	 <AANLkTikHy1pZP0=cpmSD_HG-jeJvgne3u2ivOif6DHP8@mail.gmail.com>
	 <1299725486.15854.281.camel@gandalf.stny.rr.com>
	 <1299727594.15854.310.camel@gandalf.stny.rr.com>
	 <4D787294.4040906@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 08:07:43 -0500
Message-ID: <1299762463.15854.329.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 22:41 -0800, Darren Hart wrote:
> On 03/09/2011 07:26 PM, Steven Rostedt wrote:
> > On Wed, 2011-03-09 at 21:51 -0500, Steven Rostedt wrote:
> >
> >> I'll play with some other make tricks and see if I can come up with a
> >> better solution.
> >
> > OK, it didn't take me long to come up with "Makefiles suck" ;)
> 
> Yeah, that little tidbit I sent took longer to come up with than it 
> should have :/
> 
> >
> > But I did come up with a solution:
> >
> > ifneq ("$(origin CC)", "environment")
> > CC = gcc
> > endif
> >
> > CC := $(CROSS_COMPILE)$(CC)
> 
> Why do we want to force CC=gcc? Isn't the right thing to make your OS 
> setup cc to point to your preferred compiler since it is known to be the 
> default for make?

Why not? The kernel does it. And yes, as I am following the kernel with
trace-cmd than other user space tools.

> 
> On Ubuntu, cc -> gcc
> On Fedora 13, cc -> ccache

Ug, thanks for telling me. /me goes to disable ccache from his F13
installs.

> 
> seems strange to force it to be gcc when users/distros have gone through 
> the trouble to set it up on their system.

If you define CC as a environment variable, it will work with the other
solution.

> 
> 
> > This wont let make CC=xx work unless I also add a:
> >
> > ifneq ("$(origin CC)", "command line")
> >
> > around the above if, but do we care?
> >
> 
> This starts to get to the point where others looking at it will choke on 
> the expert Makefile usage.
> 

Yeah, that took a bit of searching. Makefiles are far from being
obvious. But as you all know, I work in the world of obfuscation.
Probably why I prefer perl over python ;)

-- Steve


