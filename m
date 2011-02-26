Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204Ab1BZCro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 21:47:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44865 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1BZCrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 21:47:43 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=gkLDreHdBTAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=qaIZMmkHJNsZwyK5uYYA:9 a=8RoRl-q7X62i06oQP48A:7 a=whzEUHHMy8EYT-GLCOikD2D5do4A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
From: Steven Rostedt <rostedt@goodmis.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dominik Klein <dk@in-telegence.net>, Tejun Heo <tj@kernel.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com
In-Reply-To: <20110225201830.GK2994@redhat.com>
References: <20110222152426.GD28269@redhat.com>
	 <20110222190953.GF28269@redhat.com> <4D650D7E.4050908@in-telegence.net>
	 <4D662248.6040405@in-telegence.net> <20110224142303.GA18494@redhat.com>
	 <20110224143105.GL7840@htj.dyndns.org> <4D66720E.70102@in-telegence.net>
	 <20110224151701.GQ7840@htj.dyndns.org> <4D67591F.10105@in-telegence.net>
	 <20110225195307.GA23161@home.goodmis.org>
	 <20110225201830.GK2994@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 25 Feb 2011 21:47:40 -0500
Message-ID: <1298688460.6376.34.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-25 at 15:18 -0500, Vivek Goyal wrote:

> Thanks Steve. In this case this feature of sending trace data over
> network would have helped. We were running into issues where IO scheduler
> was freezing so we could not read anything from disk(including saved traces).
> Hence we were directing everything to console and then doing copy paste.
> 
> So sending it over network would have probably worked even in this case.
> 
> Will give trace-cmd a try next time.

Hi Vivek,

I just pushed out a hack that lets trace-cmd read the blktrace.

I found that the blktrace never exported its structure to
the /debug/tracing/events/ftrace/blktrace/format. So userspace has no
real way to know how to parse it.

Instead, I wrote a hack that creates this file semi dynamically, based
on the information of other events. I also copied a lot of the blktrace
code from the kernel so that it can print out the same format.

You need to install the plugin that is built with trace-cmd. It will
either be automatically installed if you do a make install, but if you
do not have root access, just cp the plugin_blk.so into
~/.trace-cmd/plugins directory (you may need to make that directory
yourself).  Then when you run trace-cmd report on a file made with the
blk tracer, it will give you a nice output.

If you already have a trace.dat file from a previous extract, you don't
need to run the trace again. The trace-cmd report will work on that file
now.

I'll be heading out to NYC on Monday for the End Users Conf and this
weekend I need to get all my chores done around the house for the misses
to let me go ;)  Thus, I wont be doing much more till I get back at the
end of next week.

-- Steve


