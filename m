Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab1ERQ6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:58:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252Ab1ERQ63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:58:29 -0400
Date: Wed, 18 May 2011 18:57:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 02/10] job control: introduce JOBCTL_TRAP_STOP and use
	it for group stop trap
Message-ID: <20110518165711.GA29279@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-3-git-send-email-tj@kernel.org> <20110518164814.GA28848@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518164814.GA28848@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18, Oleg Nesterov wrote:
>
> So far I can't really understand why do we have both JOBCTL_TRAP_STOP and
> and JOBCTL_TRAPPING... Please ignore, I didn't read other patches yet.

OK, SEIZE sets JOBCTL_TRAP_STOP.

> Hmm. And afaics there is a bug in do_signal_stop(), after
> "[PATCH 6/9] job control: make task_clear_jobctl_pending() clear TRAPPING automatically"
> ->jobctl &= ~JOBCTL_STOP_SIGMASK is no longer safe. We can clear _TRAPPING
> without wakeup.

And this also affects ptrace_attach(PTRACE_SEIZE), TRAP_STOP is cleared
as well.

Oleg.

