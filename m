Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab2JQRxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:53:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518Ab2JQRxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:53:20 -0400
Date: Wed, 17 Oct 2012 19:54:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH 9/9] ARM: add uprobes support
Message-ID: <20121017175424.GA12553@redhat.com>
References: <1350242593-17761-1-git-send-email-rabin@rab.in> <1350242593-17761-9-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350242593-17761-9-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14, Rabin Vincent wrote:
>
> @@ -655,6 +656,9 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
>  					return restart;
>  				}
>  				syscall = 0;
> +			} else if (thread_flags & _TIF_UPROBE) {
> +				clear_thread_flag(TIF_UPROBE);
> +				uprobe_notify_resume(regs);
>  			} else {
>  				clear_thread_flag(TIF_NOTIFY_RESUME);
>  				tracehook_notify_resume(regs);

This doesn't look right. do_signal() can modify instruction pointer
after we hit the breakpoint. IOW, uprobe_notify_resume() should be
called before do_signal().

Oleg.

