Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab1E3JwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 05:52:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38621 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab1E3Jv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 05:51:59 -0400
Message-ID: <4DE3688A.4040600@mvista.com>
Date: Mon, 30 May 2011 13:51:06 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Kgdb-bugreport] [PATCH] kgdbts: only use new asm-generic/ptrace.h
 api when needed
References: <20110527151135.cd6f758a.sfr@canb.auug.org.au> <1306591465-9622-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1306591465-9622-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 28-05-2011 18:04, Mike Frysinger wrote:

> The new instruction_pointer_set helper is defined for people who have
> converted to asm-generic/ptrace.h, so don't use it generally unless
> the arch needs it (in which case it has been converted).  This should
> fix building of kgdb tests for arches not yet converted.

> Signed-off-by: Mike Frysinger<vapier@gentoo.org>
> ---
>   drivers/misc/kgdbts.c |    5 ++++-
>   1 files changed, 4 insertions(+), 1 deletions(-)

> diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
> index b0c5631..8cebec5 100644
> --- a/drivers/misc/kgdbts.c
> +++ b/drivers/misc/kgdbts.c
> @@ -304,7 +304,10 @@ static int check_and_rewind_pc(char *put_str, char *arg)
>   		return 1;
>   	}
>   	/* Readjust the instruction pointer if needed */
> -	instruction_pointer_set(&kgdbts_regs, ip + offset);
> +	ip += offset;

    Since 'íp' is local, incrementing it is pointless here unless you have 
GDB_ADJUSTS_BREAK_OFFSET defined. Why not keep instruction_pointer_set() call 
as is?

> +#ifdef GDB_ADJUSTS_BREAK_OFFSET
> +	instruction_pointer_set(&kgdbts_regs, ip);
> +#endif
>   	return 0;
>   }
>

WBR, Sergei
