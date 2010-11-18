Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0KRLtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:49:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60639 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab0KRLtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:49:45 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=emhYPqQk1oIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=T_p62HLcd08g1Ug9na4A:9 a=cx7NPlu8XbOPI3P2IycA:7 a=o3Utly0tHdj8ni78G8_CPmbtPT0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [ANNOUNCE v2] ktest.pl: Easy and flexible testing script for
 Linux Kernel Developers (now with config bisect)
From: Steven Rostedt <rostedt@goodmis.org>
To: Jon Masters <jcm@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>, lmr@redhat.com,
        Greg Kroah-Hartman <gregkh@suse.de>, autotest@test.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Clark Williams <williams@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <1290063785.3916.1124.camel@constitution.bos.jonmasters.org>
References: <1289259910.12418.77.camel@gandalf.stny.rr.com>
	 <1290063785.3916.1124.camel@constitution.bos.jonmasters.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 18 Nov 2010 06:49:40 -0500
Message-ID: <1290080980.30543.92.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 02:03 -0500, Jon Masters wrote:
> On Mon, 2010-11-08 at 18:45 -0500, Steven Rostedt wrote:
> 
> > It compiles, and performs the type of test specified by the
> > CONFIG_BISECT_TYPE option (build, boot or test). If it passes, then all
> > the configs that were enabled in the .config are removed from the
> > configs to test and added to the good configs to always enable. This
> > allows for configs in the other half to be enabled if they depended on
> > these configs.
> 
> Haven't had time to play, but I was thinking about this when bisecting
> an i915 bug last week. In that case none of the kernels failed to boot,
> they just had busted modelines. Do you have support in this tool for
> testing some condition on the system after it boots? I would guess I
> probably would have needed something more heavyweight (that could run a
> script to look for busted modes on the target after booting).

If you set:

BISECT_TYPE = test
TEST = ssh user@host test_script

Where the test_script resides on the test target, and will exit with 0
on success and non-0 otherwise, it should work.

I could also change the code to give you access to the bootlog (actually
you already have it, but it's in the temp directory).

-- Steve


