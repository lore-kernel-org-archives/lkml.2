Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995Ab2DREGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:06:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab2DREGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:06:37 -0400
Date: Wed, 18 Apr 2012 00:06:32 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
Message-ID: <20120418040632.GB31465@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120417172142.GA30237@redhat.com>
 <CA+55aFy-uhOgEoEBr-LkOjFQBVh14wwr-20jTrtsg_2EnuNY5g@mail.gmail.com>
 <20120417203223.GA31699@redhat.com>
 <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
 <20120418022705.GA23877@home.goodmis.org>
 <20120418031557.GA29828@redhat.com>
 <1334720611.28106.25.camel@gandalf.stny.rr.com>
 <20120418035004.GA31465@redhat.com>
 <1334721441.28106.28.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334721441.28106.28.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 11:57:21PM -0400, Steven Rostedt wrote:
 
 > >  > This would show what functions the stack tracer is using.
 > >  > 
 > >  > I just compiled the latest vanilla kernel and tried it out, and it
 > >  > worked for me.
 > > 
 > > works on my other machines too with similar kernel configs, just not on the one I'm profiling.
 > 
 > I have to ask. Is this a x86 box?

yeah, 64-bit Xeon circa 2008.
 
 > Also, have you tested to see if function tracing works?
 > 
 > # cd /sys/kernel/debug/tracing
 > # echo function > current_tracer
 > # cat trace
 > 
 > If function tracing doesn't work this wouldn't either.

That just prints out..

# tracer: function
#
# entries-in-buffer/entries-written: 0/0   #P:4
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |

 > I'm also assuming you have CONFIG_STACKTRACE and
 > CONFIG_STACKTRACE_SUPPORT enabled. They should be selected, but configs
 > can always get screwed up.

CONFIG_STACKTRACE_SUPPORT=y
CONFIG_STACKTRACE=y

	Dave
