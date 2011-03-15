Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1COCj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 22:39:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58167 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1COCj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 22:39:56 -0400
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=OYR2tiJNacsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=_jIf4JBWPqfGgvdmkJUA:9 a=7iE0anAJ6kDQZTVTwIjygZmy2TIA:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] ftrace: add a new 'tail drops' counter for overflow
 events
From: Steven Rostedt <rostedt@goodmis.org>
To: Slava Pestov <slavapestov@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com, dhsharp@google.com
In-Reply-To: <1300143236-23233-1-git-send-email-slavapestov@google.com>
References: <1300143236-23233-1-git-send-email-slavapestov@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Mar 2011 22:39:54 -0400
Message-ID: <1300156794.9910.249.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 15:53 -0700, Slava Pestov wrote:
> The existing 'overrun' counter is incremented when the ring
> buffer wraps around, with overflow on (the default). We wanted
> a way to count requests lost from the buffer filling up with
> overflow off, too. I decided to add a new counter instead
> of retro-fitting the existing one because it seems like a
> different statistic to count conceptually, and also because
> of how the code was structured.

So this is when we are in producer/consumer mode and the ring buffer
fills up and events are dropped.

For this we could just add a new ring buffer type. We could use the
RINGBUF_TYPE_TIME_STAMP as and call it RINGBUF_TYPE_LOST_EVENTS instead.
I never implemented the TIME_STAMP as I never found a need to ;)

As we currently have a TIME_EXTEND that is still relative from the last
event but has a total of 59 bits for time. That being nanoseconds we can
handle events that are 18 years apart. That far apart and never being
read.

The LOST_EVENTS could store the number of events lost when it starts
reading again. This way raw readers will know that events were lost and
how many.

-- Steve


> 
> Signed-Off-By: Slava Pestov <slavapestov@google.com>


