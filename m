Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab2IMPGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:06:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab2IMPGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:06:21 -0400
Date: Thu, 13 Sep 2012 17:08:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [PATCH 1/2] coredump: pass siginfo_t* to do_coredump() and
	below, not merely signr
Message-ID: <20120913150826.GA32128@redhat.com>
References: <1347493124-10661-1-git-send-email-vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347493124-10661-1-git-send-email-vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13, Denys Vlasenko wrote:
>
> This is a preparatory patch for the introduction of NT_SIGINFO elf note.

I think the changelog should explain what the patch does.

With this patch we pass "siginfo_t *info" instead of "int signr" to
do_coredump() and put it into coredump_params, this "info" will be used
by the next patch. Other changes are simple s/signr/info->si_signo/.

> @@ -524,7 +524,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  	 */
>  	clear_thread_flag(TIF_SIGPENDING);
>  
> -	ispipe = format_corename(&cn, signr);
> +	ispipe = format_corename(&cn, info->si_signo);

Well, this conflicts with another fix which we discussed privately,
perhaps it would be better to push that simple change first...
But OK, this conflict is trivial.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

