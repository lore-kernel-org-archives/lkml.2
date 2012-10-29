Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab2J2MJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 08:09:48 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:55103 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754978Ab2J2MJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 08:09:47 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19gxV9Zh6dg5a4SS9OLgWo4rwdcAMJ0H+/NWFYsxZ
	TMANJHOer4KF+C
Message-ID: <1351512615.9785.25.camel@maggy.simpson.net>
Subject: Re: [PATCH] V2 sched, autogroup: fix crash on reboot when autogroup
 is disabled
From: Mike Galbraith <efault@gmx.de>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Mon, 29 Oct 2012 05:10:15 -0700
In-Reply-To: <CAJn8CcFO9BB7yfoo2158FPV75Za7yoYqrf_KfwPdA-AdkT=Qsw@mail.gmail.com>
References: <1350635770-9189-1-git-send-email-xtfeng@gmail.com>
	 <1350654126.2768.5.camel@twins>
	 <CAJn8CcE5McFB-FH981Pj+eahNOt8ck3ncJwD4xocU_LrAtjBHA@mail.gmail.com>
	 <1350736696.5123.24.camel@maggy.simpson.net>
	 <1351283371.16639.111.camel@maggy.simpson.net>
	 <1351362370.4503.3.camel@maggy.simpson.net>
	 <20121028102520.GA7711@gmail.com>
	 <1351430004.8685.17.camel@maggy.simpson.net>
	 <20121028131950.GA15159@gmail.com>
	 <1351431201.8685.22.camel@maggy.simpson.net>
	 <20121028140544.GA28216@gmail.com>
	 <1351451963.4999.8.camel@maggy.simpson.net>
	 <CAJn8CcFO9BB7yfoo2158FPV75Za7yoYqrf_KfwPdA-AdkT=Qsw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 10:42 +0800, Xiaotian Feng wrote:

> I'm okay with the removal of runtime enable/disable autogroup. But can
> we simply remove
> these two knobs that is already exposed to user space since 2.6.38 ?
> So we can't cat /proc/<pid>/autogroup
> or echo <nice level> > /proc/<pid>/autogroup anymore even if autogroup is on?

I should have never made those knobs, as it's against the whole idea of
automatic no muss no fuss group scheduling.  If you want knobs, you want
full cgroups, so I think we should call this a fix opportunity.

If the knobs are seen as being cast in stone, I'll do the full move for
the on/off switch instead, and there will be no user visible change. I'd
rather not do that.  This way, it's really out of the way when disabled,
smaller and simpler is better for this feature.

It's a dinky little sidelines feature, so let's just quietly make kaboom
go away, non-functional on/off go away, along with the silly knobs which
will make kaboom unless you jump through hoops just to keep them alive. 

-Mike

