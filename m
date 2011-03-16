Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1CPLfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 07:35:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:12998 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab1CPLfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 07:35:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,193,1299484800"; 
   d="scan'208";a="897830811"
Date: Wed, 16 Mar 2011 04:35:45 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        containers@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org
Subject: Re: [PATCH, v9 3/3] cgroups: introduce timer slack controller
Message-ID: <20110316043545.493c7b36@jacob-laptop>
In-Reply-To: <20110314164652.5b44fb9e.akpm@linux-foundation.org>
References: <1300111524-5666-1-git-send-email-kirill@shutemov.name>
	<1300111524-5666-4-git-send-email-kirill@shutemov.name>
	<20110314164652.5b44fb9e.akpm@linux-foundation.org>
Organization: OTC
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011 16:46:52 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 14 Mar 2011 16:05:24 +0200
> Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> 
> > +Overview
> > +--------
> > +
> > +Every task_struct has timer_slack_ns value. This value uses to
> > round up +poll() and select() timeout values. This feature can be
> > useful in +mobile environment where combined wakeups are desired.
> > +
> > +Originally, prctl() was the only way to change timer slack value of
> > +a process. So you was not able change timer slack value of another
> > +process.
> > +
> > +cgroup subsys "timer_slack" implements timer slack controller. It
> > +provides a way to set minimal timer slack value for a group of
> > tasks. +If a task belongs to a cgroup with minimal timer slack
> > value higher than +task's value, cgroup's value will be applied.
> > +
> > +Timer slack controller allows to implement setting timer slack
> > value of +a process based on a policy. For example, you can create
> > foreground and +background cgroups and move tasks between them
> > based on system state.
> 
> (quoting myself from last time)
> 
> Why do we need a cgroup for this as opposed to (say) inheritance over
> fork(), or a system-wide knob, or a per-process/threadgroup knob, or
> just leaving the existing code as-is?  Presumably you felt that a
> cgroup approach is better for manageability, but you didn't tell us
> about this and you didn't explore alternative ways of solving the
> problem-which-you-didn't-describe.
> 
> 
> 
> 
> I'm still having trouble seeing why we should merge this.  Who will
> use it, and for what reason and what benefits will they see?
> Quantified benefits, if possible!
> 
I am planning to use it for doing resource management for a mobile
device where we classify applications by groups based on priority and
trust level. Then at runtime, I plan to use timer slack as one of the
knobs to penalize/manage them at different degree to reduce power
consumption (via reduction of #wake-ups in this case).

Thanks,

Jacob
