Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab2GXSTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 14:19:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55716 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab2GXSTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 14:19:03 -0400
Date: Tue, 24 Jul 2012 11:18:58 -0700
From: Tejun Heo <tj@kernel.org>
To: "Maxim V. Patlasov" <mpatlasov@parallels.com>
Cc: Olof Johansson <olof@lixom.net>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION] [PATCH] block: uninitialized ioc->nr_tasks
 triggers WARN_ON
Message-ID: <20120724181858.GB5776@google.com>
References: <20120717213643.GA24726@quad.lixom.net>
 <20120717222444.GG24336@google.com>
 <500EA4A2.8050806@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <500EA4A2.8050806@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 24, 2012 at 05:35:30PM +0400, Maxim V. Patlasov wrote:
> 07/18/2012 02:24 AM, Tejun Heo пишет:
> >Hello, Olof.
> >
> >On Tue, Jul 17, 2012 at 02:36:43PM -0700, Olof Johansson wrote:
> >>It seems like the init of ioc->nr_tasks was removed in that patch,
> >>so it starts out at 0 instead of 1.
> >>
> >>Tejun, is the right thing here to add back the init, or should something else
> >>be done?
> >>
> >>The below patch removes the warning, but I haven't done any more extensive
> >>testing on it.
> >>
> >>
> >>Signed-off-by: Olof Johansson <olof@lixom.net>
> >Right, the patch shouldn't have replaced the init.
> >
> >  Acked-by: Tejun Heo <tj@kernel.org>
> >
> >Fortunately, the effect of the bug is limited.  ioc->nr_tasks only
> >used to veto block cgroup migration if a task has ioc which is shared
> >by multiple tasks.  Currently, the only known program using CLONE_IO
> >is dump and even if somebody migrates some threads of a single dump
> >instance to a different block cgroup, the result won't be catastrophic
> >although block cgroup policies would become ambiguous.  IMHO, it
> >should be okay to route this through -stable after 3.5.  Jens?
> 
> Please notice that annoying WARN_ON comes from world-visible
> ioc_task_link(). So any third-party module using ioc_task_link()
> ends up in that clutter in logs. E.g. OpenVZ ploop block-device uses
> ioc_task_link().

This should go through block tree.  Jens, ping.

Thanks.

-- 
tejun
