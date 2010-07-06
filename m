Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab0GFNXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 09:23:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab0GFNXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 09:23:35 -0400
Date: Tue, 6 Jul 2010 09:23:19 -0400
From: Don Zickus <dzickus@redhat.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/watchdog: Initialize 'result'
Message-ID: <20100706132319.GT5381@redhat.com>
References: <1278316854-28442-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1278316854-28442-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 12:00:54PM +0400, Kulikov Vasiliy wrote:
> Variable on the stack is not initialized to zero, do it explicitly.
> 
> This patch silences a compiler warning:
> kernel/watchdog.c:463: warning: ‘result’ may be used uninitialized in this function

Hmm, I thought I fixed that.  oh well.

ACK.

> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  kernel/watchdog.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 91b0b26..613bc1f 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -460,7 +460,7 @@ static void watchdog_disable(int cpu)
>  static void watchdog_enable_all_cpus(void)
>  {
>  	int cpu;
> -	int result;
> +	int result = 0;
>  
>  	for_each_online_cpu(cpu)
>  		result += watchdog_enable(cpu);
> -- 
> 1.7.0.4
> 
