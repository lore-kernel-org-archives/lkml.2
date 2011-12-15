Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563Ab1LOWAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:00:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab1LOWAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:00:30 -0500
Date: Thu, 15 Dec 2011 14:00:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>, serge.hallyn@canonical.com,
        containers@lists.linux-foundation.org, gkurz@fr.ibm.com,
        linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
Subject: Re: [PATCH][V4] Add reboot_pid_ns to handle the reboot syscall
Message-Id: <20111215140028.e1b8a6a7.akpm@linux-foundation.org>
In-Reply-To: <20111214191739.GA14693@redhat.com>
References: <1323649064-7960-1-git-send-email-daniel.lezcano@free.fr>
	<1323649064-7960-2-git-send-email-daniel.lezcano@free.fr>
	<20111213162242.1ab3cb1a.akpm@linux-foundation.org>
	<20111214191739.GA14693@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011 20:17:39 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> > It would be
> > better to do
> >
> > #ifdef CONFIG_PID_NS
> > extern void pidns_handle_reboot(int cmd);
> > #else
> > static inline void pidns_handle_reboot(int cmd)
> > {
> > }
> > #endif
> 
> Can't resist.
> 
> Why the kernel always prefers to do it this way, adding the ugly
> do-nothing inlines?
> 
> Isn't it better to simply call pidns_handle_reboot(cmd) under
> CONFIG_PID_NS in sys_reboot() ?
> 
> 	#ifdef CONFIG_PID_NS
> 	if (task_active_pid_ns(current) != &init_pid_ns)
> 		return reboot_pid_ns(cmd);
> 	#endif

Imagine what the code would look like if we took all the existing empty
inline stubs and replaced them with #if/#else/#endif.
