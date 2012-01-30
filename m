Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab2A3UhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:37:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab2A3UhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:37:09 -0500
Date: Mon, 30 Jan 2012 18:36:54 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, robert.richter@amd.com,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] perf: fix broken perf inject -b
Message-ID: <20120130203653.GD5797@infradead.org>
References: <20120113144731.GA5458@quad> <20120113165315.GA24387@infradead.org> <CABPqkBTe1uqiLm02fijYE2bwF=rWWu=V0mjZQbEzW0TUKa4-+Q@mail.gmail.com> <CABPqkBS50jYOHepmAqOzGYY8m+4SCJQuhrMV2yLXRYfdFpE70g@mail.gmail.com> <20120130190008.GA5797@infradead.org> <CABPqkBSzgc7WSbuS4L1gtCf+3u_q3fx002byArsMjKSxd5zw-g@mail.gmail.com> <20120130200432.GC5797@infradead.org> <CABPqkBQu=82igQV2O_UmJsuDOHh8_VyRQCUGmrGqTBvnEdyN+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBQu=82igQV2O_UmJsuDOHh8_VyRQCUGmrGqTBvnEdyN+Q@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 30, 2012 at 09:09:17PM +0100, Stephane Eranian escreveu:
> On Mon, Jan 30, 2012 at 9:04 PM, Arnaldo Carvalho de Melo
> <acme@redhat.com> wrote:
> > Em Mon, Jan 30, 2012 at 08:53:26PM +0100, Stephane Eranian escreveu:
> >> On Mon, Jan 30, 2012 at 8:00 PM, Arnaldo Carvalho de Melo
> >> <acme@redhat.com> wrote:
> >> > > >>> @@ -173,6 +178,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
> >> > > >>>               goto repipe;
> >> > > >>>       }
> >> > > >>> +     machine->pid = event->ip.pid;
> >> >
> >> > > I noticed that this statement conflicts with perf buildid-list (which
> >> > > I am also fixing for pipe mode).

> >> > > I don't quite understand why, though.

> >> > Have you reached any conclusion about this problem? I haven't looked at
> >> > it in detail, could you please elaborate more?

> >> I ended up removing it. But I am not sure this is correct.
> >> Is the pid used in any way when processing buildids?
> >
> > I can't think of any.
> >
> > The same DSO could conceivably be present in the virtual machine, the
> > host, and in the workstation used for perf report.  We just use the
> > build-id in the perf.data file to find the right symtab.

> Right, so I don't know why it's there...

This comes from a1645ce1:

commit a1645ce12adb6c9cc9e19d7695466204e3f017fe
Author: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date:   Mon Apr 19 13:32:50 2010 +0800

    perf: 'perf kvm' tool for monitoring guest performance from host
    
    Here is the patch of userspace perf tool.
    
    Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
    Signed-off-by: Avi Kivity <avi@redhat.com>



Zhang, what was the thinking about that pid in the buildid event?

>From what I can see we can just ignore it :-\

- Arnaldo
