Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2AQSU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:20:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab2AQSUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:20:55 -0500
Date: Tue, 17 Jan 2012 19:14:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children
	entry v6
Message-ID: <20120117181436.GA21807@redhat.com>
References: <20120116153231.GF2998@moon> <20120116161114.GA17727@redhat.com> <20120116162021.GH2998@moon> <20120117174049.GA19268@redhat.com> <20120117175725.GJ16213@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117175725.GJ16213@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17, Cyrill Gorcunov wrote:
>
> On Tue, Jan 17, 2012 at 06:40:49PM +0100, Oleg Nesterov wrote:
> ...
> > > >
> > > > But this is not enough. exit_ptrace() can do list_move() without
> > > > changing ->real_parent.
> > > >
> > > > I'll try to think. At first glance we can rely on EXIT_DEAD, but
> > > > I'd like to avoid this, I think EXIT_DEAD should die.
> > >
> > > Ouch! Thanks for catching this Oleg. I'll try to come with something
> > > to show as well.
> >
> > Do you see another approach? I don't, so I'd suggest to check
> > "task->exit_state != EXIT_DEAD" instead of !list_empty().
> >
>
> Well, I thought what if I can find another way without EXIT_DEAD
> but seems there is no luck.

Oooooh. Cyrill, it seems I managed to confuse you. And myself.

exit_ptrace() doesn't use ->sibling, it uses ->ptrace_entry!.

Sorry!

Oleg.

