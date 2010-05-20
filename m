Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab0ETTc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 15:32:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886Ab0ETTc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 15:32:58 -0400
Date: Thu, 20 May 2010 12:31:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Vagin <avagin@openvz.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Emelyanov <xemul@openvz.org>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH 2/3] posix_timer: fix error path in timer_create
Message-Id: <20100520123155.c4b7a1ed.akpm@linux-foundation.org>
In-Reply-To: <1274116688-4037-2-git-send-email-avagin@openvz.org>
References: <1274116688-4037-1-git-send-email-avagin@openvz.org>
	<1274116688-4037-2-git-send-email-avagin@openvz.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 21:18:07 +0400
Andrey Vagin <avagin@openvz.org> wrote:

> move CLOCK_DISPATCH(which_clock, timer_create, (new_timer)) after all
> posible EFAULT erros.
> 
> *_timer_create may allocate/get resources.
> (for example posix_cpu_timer_create does get_task_struct)
> 

You've added a Cc:stable@kernel.org to the mail headers, but there is
no "Cc: <stable@kernel.org>" in the changelog.  Please, if you think a
patch should go into -stable then add the tag to the changelog also -
this is more reliable and explicit than spraying things at a mailing
list.

You cc'ed stable@kernel.org on all three patches but IMO only [2/3]
(this patch) is needed in -stable.

And afaict, the bug which this patch fixes will allow a suitably-nasty
unprivileged application to leak an unbounded number of task-structs,
which is a box-killing local DoS.  So yes, -stable wants this.

