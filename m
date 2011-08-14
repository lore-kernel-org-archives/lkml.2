Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1HNQgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:36:55 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:42892 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab1HNQgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:36:53 -0400
Date: Sun, 14 Aug 2011 18:36:11 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>,
        containers@lists.linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] add SA_CLDREBOOT flag
Message-ID: <20110814183611.05937c96@neptune.home>
In-Reply-To: <20110814161532.GA30846@redhat.com>
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr>
	<1313094241-3674-2-git-send-email-daniel.lezcano@free.fr>
	<20110814161532.GA30846@redhat.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 August 2011 Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/11, Daniel Lezcano wrote:
> >
> > Add the SA_CLDREBOOT flag to enable the CLD_REBOOT on SIGCHLD
> > when a process of a child pid namespace calls the reboot syscall.
> 
> I doubt this is really useful in general. SIGCHLD doesn't queue,
> if the parent of init already has the pending SIGCHLD it won't see
> CLD_REBOOTED anyway. Anyway, you do not need a special helper to
> fill siginfo.
> 
> And personally I strongly dislike SA_CLDREBOOT. For what? Imho, this
> is unnecessary complication. If we want SIGCHLD-on-reboot, just send
> it unconditionally.

The information that is needed is what options the container did pass
to sys_reboot().
Did the container want a reboot or a power-off (or maybe just touch the
LINUX_REBOOT_CMD_CAD_* status)?

As long as that information can reach parent/reaper of container's init
the needed functionality should be there.

Bruno
