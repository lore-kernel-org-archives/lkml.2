Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab0D3SIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:08:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932551Ab0D3SIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:08:24 -0400
Date: Fri, 30 Apr 2010 20:05:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 2/2] workqueues: export keventd_wq
Message-ID: <20100430180520.GB9043@redhat.com>
References: <1272429119-12103-1-git-send-email-arve@android.com> <20100428194028.GA16389@redhat.com> <4BD89922.1040306@kernel.org> <201004282308.10751.rjw@sisk.pl> <20100429185851.GA13862@redhat.com> <20100429194447.GA17280@redhat.com> <20100429194545.GC17280@redhat.com> <4BDA67C1.7050709@kernel.org> <t2gd6200be21004292239r582b8a43l2409491b8d32ef1b@mail.gmail.com> <4BDA700C.3050509@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BDA700C.3050509@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30, Tejun Heo wrote:
>
> On 04/30/2010 07:39 AM, Arve Hjønnevåg wrote:
> > On Thu, Apr 29, 2010 at 10:16 PM, Tejun Heo <tj@kernel.org> wrote:
> >> Hello,
> >>
> >> On 04/29/2010 09:45 PM, Oleg Nesterov wrote:
> >>> -static struct workqueue_struct *keventd_wq __read_mostly;
> >>> +struct workqueue_struct *keventd_wq __read_mostly;
> >>> +EXPORT_SYMBOL(keventd_wq);
> >>
> >> Umm... does it have to be EXPORTed?  Suspend block API can't be built
> >> as a module, right?

Right, but this allows to make schedule_xxx/flush_scheduled_work
inline and kill more EXPORT_SYMBOL's, and cmwq exports it anyway
(iirc it also renames it).

> > The suspend block api cannot be built as a module, but if
> > schedule_suspend_blocking_work will just call
> > queue_suspend_blocking_work(keventd_wq, work) it may as well be an
> > inline function which would require the export.
>
> I think it would be better to keep the thing inside the kernel, at
> least for now.

But then schedule_suspend_blocking_work() in turn needs EXPORT_SYMBOL().


OK. Let's forget this patch. We can unify schedule_suspend_blocking_work
and queue_suspend_blocking_work later, or Arve can add this export into
his patch (without EXPORT_SYMBOL) - either way I agree. This is very
minor issue, I regret I originated this almost offtopic noise ;)

Oleg.

