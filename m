Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab1HSP2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:28:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab1HSP2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:28:14 -0400
Date: Fri, 19 Aug 2011 17:24:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, akpm@linux-foundation.org,
        bonbons@linux-vserver.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
	when reboot
Message-ID: <20110819152416.GA17034@redhat.com>
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr> <20110814161707.GB30846@redhat.com> <20110814213642.GB13799@hallyn.com> <20110815144744.GA9660@redhat.com> <4E4DA461.8030006@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4DA461.8030006@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19, Daniel Lezcano wrote:
>
> On 08/15/2011 04:47 PM, Oleg Nesterov wrote:
> >
> > 	- sys_reboot(cmd) does
> >
> > 		if (!global_namespace) {
> > 			task_active_pid_ns(current)->reboot_cmd = cmd;
> > 			sigkill_my_init();
> > 		}
>
> Hi Oleg,
>
> what would be your advice to get rid of from_ancestor_ns which prevent
> the signal to be delivered to the init process ?

Sure, a plain kill can't work. You can do force_sig_info(), this clears
SIGNAL_UNKILLABLE.

Hmm. But now I seem to recall we have other reasons to make the new
sigkill_task() helper... We will see. Anyway, force_ should work afaics.

Oleg.

