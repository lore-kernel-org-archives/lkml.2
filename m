Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab0IBQfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 12:35:20 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:27604 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab0IBQfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 12:35:18 -0400
Message-ID: <4C7FD244.8050502@tilera.com>
Date: Thu, 2 Sep 2010 12:35:16 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 22/24] ptrace: cleanup arch_ptrace() on tile
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com> <1283442391-23612-23-git-send-email-namhyung@gmail.com>
In-Reply-To: <1283442391-23612-23-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 9/2/2010 11:46 AM, Namhyung Kim wrote:
> Remove checking @addr less than 0 because @addr is now unsigned.
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/kernel/ptrace.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
> index aed9256..704bf11 100644
> --- a/arch/tile/kernel/ptrace.c
> +++ b/arch/tile/kernel/ptrace.c
> @@ -85,7 +85,7 @@ long arch_ptrace(struct task_struct *child, long request,
>  	case PTRACE_PEEKUSR:  /* Read register from pt_regs. */
>  		if (addr & (sizeof(data)-1))
>  			break;
> -		if (addr < 0 || addr >= PTREGS_SIZE)
> +		if (addr >= PTREGS_SIZE)
>  			break;
>  		tmp = getreg(child, addr);   /* Read register */
>  		ret = put_user(tmp, datap);
> @@ -94,7 +94,7 @@ long arch_ptrace(struct task_struct *child, long request,
>  	case PTRACE_POKEUSR:  /* Write register in pt_regs. */
>  		if (addr & (sizeof(data)-1))
>  			break;
> -		if (addr < 0 || addr >= PTREGS_SIZE)
> +		if (addr >= PTREGS_SIZE)
>  			break;
>  		putreg(child, addr, data);   /* Write register */
>  		ret = 0;

This omits the change to the actual function definition, which was present
in the previous version of this patch.

On the up side, it also removes the change to the sizeof() values in
GETREGS/SETREGS, which seemed unnecessary in the previous version.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

