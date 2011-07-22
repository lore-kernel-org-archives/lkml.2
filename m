Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1GVIoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 04:44:37 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:60032 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab1GVIof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 04:44:35 -0400
Date: Fri, 22 Jul 2011 10:44:30 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, mtk.manpages@gmail.com,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: do_wait(traced_leader_killed_by_mt_exec) can
 block forever
Message-ID: <20110722084430.GF2622@htj.dyndns.org>
References: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com>
 <20110721165137.GA21345@redhat.com>
 <20110721180019.GA1319@redhat.com>
 <20110721180043.GB1319@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721180043.GB1319@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jul 21, 2011 at 08:00:43PM +0200, Oleg Nesterov wrote:
> It is racy, exit_notify() does __wake_up_parent() too. But in the
> likely case it triggers the problem: de_thread() does release_task()
> and the old leader goes away without the notification, the tracer
> sleeps in do_wait() without children/tracees.
> 
> Change de_thread() to do __wake_up_parent(traced_leader->parent).
> Since it is already EXIT_DEAD we can do this without ptrace_unlink(),
> EXIT_DEAD threads do not exist from do_wait's pov.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Nice catch as always. :)

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
