Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab1IXClh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 22:41:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50394 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab1IXClg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 22:41:36 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=OuXuCX0A07wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=1XWaLZrsAAAA:8 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=omOdbC7AAAAA:8 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8 a=Z4Rwk6OoAAAA:8 a=JfrnYn6hAAAA:8 a=NufY4J3AAAAA:8 a=ufHFDILaAAAA:8 a=VwQbUJbxAAAA:8 a=XRgG1S5bOetsobFjeh8A:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jbrJJM5MRmoA:10 a=Zh68SRI7RUMA:10 a=3Rfx1nUSh_UA:10 a=re9sYKne76oA:10 a=l7ZknGph1ugA:10 a=aUmrPQVLkos04fXW:21 a=CCsZalvXGc49xW1j:21 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH] memcg: Fix race condition in memcg_check_events() with
 this_cpu usage
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Thelen <gthelen@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        bsingharora@gmail.com, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        PeterZijlstra <peterz@infradead.org>, ChristophLameter <cl@linux.com>
Date: Fri, 23 Sep 2011 22:41:32 -0400
In-Reply-To: <CAHH2K0agLygD6cREazsTquCT=Whx97RxxhOneWpVF1cHwMwp3A@mail.gmail.com>
References: <1316825684.6387.5.camel@gandalf.stny.rr.com>
	 <CAHH2K0Z_MsVceOjoFwT=qORSsKrFWjs_V602NMtPBysasJLEww@mail.gmail.com>
	 <CAHH2K0agLygD6cREazsTquCT=Whx97RxxhOneWpVF1cHwMwp3A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1316832094.6387.11.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 19:39 -0700, Greg Thelen wrote:
> cc: updated Balbir Singh email address
> 
> On Fri, Sep 23, 2011 at 7:34 PM, Greg Thelen <gthelen@google.com> wrote:
> > On Fri, Sep 23, 2011 at 5:54 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >> From: Steven Rostedt <srostedt@redhat.com>
> >>
> >> The code in memcg_check_events() calls this_cpu_read() on
> >> different variables without disabling preemption, and can cause
> >> the calculations to be done from two different CPU variables.
> >>
> >> Disable preemption throughout the check to keep apples and oranges
> >> from becoming a mixed drink.
> >>
> >> [ Added this_cpu to __this_cpu conversion by Johannes ]
> >>
> >> Cc: Greg Thelen <gthelen@google.com>
> >> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> Correction:
> Cc: Balbir Singh <bsingharora@gmail.com>

Thanks, I was starting to hate that "return mail to sender" thing.

-- Steve

> 
> >> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: Thomas Gleixner <tglx@linutronix.de>
> >> Cc: Peter Zijlstra <peterz@infradead.org>
> >> Cc: Christoph Lameter <cl@linux.com>
> >> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> >> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> >> Link: http://lkml.kernel.org/r/20110919212641.015320989@goodmis.org
> >
> > Looks good to me.  Thanks.
> >
> > Reviewed-by: Greg Thelen <gthelen@google.com>
> >


