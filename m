Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab1CJD0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 22:26:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59268 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab1CJD0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 22:26:35 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=XbqWoAS_rckA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=gUSI3KXUzMLODStIMpcA:9 a=cj2_TIY3_YZFd4OatKbuhkfJIjUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional
 assignment of CC and AR"
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: Darren Hart <dvhart@linux.intel.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com
In-Reply-To: <1299725486.15854.281.camel@gandalf.stny.rr.com>
References: <1299715137-22768-1-git-send-email-dhsharp@google.com>
	 <1299715137-22768-3-git-send-email-dhsharp@google.com>
	 <4D7828F9.7000906@linux.intel.com>
	 <1299720997.15854.276.camel@gandalf.stny.rr.com>
	 <4D783038.8080103@linux.intel.com>
	 <AANLkTikHy1pZP0=cpmSD_HG-jeJvgne3u2ivOif6DHP8@mail.gmail.com>
	 <1299725486.15854.281.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 09 Mar 2011 22:26:34 -0500
Message-ID: <1299727594.15854.310.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 21:51 -0500, Steven Rostedt wrote:

> I'll play with some other make tricks and see if I can come up with a
> better solution.

OK, it didn't take me long to come up with "Makefiles suck" ;)

But I did come up with a solution:

ifneq ("$(origin CC)", "environment")
CC = gcc
endif

CC := $(CROSS_COMPILE)$(CC)

This wont let make CC=xx work unless I also add a:

ifneq ("$(origin CC)", "command line")

around the above if, but do we care?

-- Steve


