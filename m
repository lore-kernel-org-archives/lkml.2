Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab1C3Seu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 14:34:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab1C3Set (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 14:34:49 -0400
Date: Wed, 30 Mar 2011 14:34:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>
Subject: Re: Why do we use cpu nice priority for ioprio?
Message-ID: <20110330183446.GG1291@redhat.com>
References: <BANLkTimiL5VZki4oUaw5hQYgB=E2jYwKrw@mail.gmail.com>
 <4D8C48B6.6050300@fusionio.com>
 <BANLkTimzt7QhBdayBpB3dRSOSY3G3VCfcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimzt7QhBdayBpB3dRSOSY3G3VCfcw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 11:23:45AM -0700, Justin TerAvest wrote:
> On Fri, Mar 25, 2011 at 12:48 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
> > On 2011-03-25 03:38, Justin TerAvest wrote:
> >> It's not clear why the cpu nice value should be mapped to the ioprio
> >> for a task when none is picked.
> >>
> >> Internally, at cfq_init_prio_data(), we just set:
> >>               ioprio = IOPRIO_NORM;
> >>               ioprio_class = IOPRIO_CLASS_BE;
> >> if ioprio_class is IOPRIO_CLASS_NONE.
> >>
> >>
> >> The problem is that  today, SCHED_RR and SCHED_FIFO threads
> >> automatically get bumped up to RT class. This all happens behind the
> >> curtains and the io_class of the thread is still shown as NONE with
> >> sys_ioprio_get(). What's the motivation behind this promotion of
> >> ioprio class?
> >
> > It was decided back in the day when io priorities were introduced. I
> > still think it's a good idea.
> 
> This is the part I'm especially curious about. If we're managing the
> resources separately,
> why should be be adjusting io_class based on the nice value?

What's wrong with taking a hint about ioclass and ioprio from cpu
scheduling class and nice value?

I think in general if some task is important from cpu perspective then
most likely it is important from IO perspective too. And if user thinks
otherwise, then one can explicitly set ioclass and ioprio of the task.

So this makes sense to me.

Thanks
Vivek
