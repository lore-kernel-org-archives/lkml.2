Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1CURVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:21:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab1CURVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:21:46 -0400
Date: Mon, 21 Mar 2011 18:12:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 6/8] job control: Job control stop notifications should
	always go to the real parent
Message-ID: <20110321171216.GA29492@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org> <1299614199-25142-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299614199-25142-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Tejun Heo wrote:
>
> The stopped notifications in do_signal_stop() and exit_signals() are
> always for the completion of job control.  The one in do_signal_stop()
> may be delivered to the ptracer if PTRACE_ATTACH races with
> notification and the one in exit_signals() if task exits while
> ptraced.
>
> In both cases, the notifications are meaningless and confusing to the
> ptracer as it never accesses the group stop state while the real
> parent would miss notifications for the events it is watching.
>
> Make sure these notifications always go to the real parent by calling
> do_notify_parent_cld_stop() with %false @for_ptrace.

Yes, looks correct.

Oleg.

