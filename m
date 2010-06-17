Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390Ab0FQRNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:13:20 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16481 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760354Ab0FQRNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:13:19 -0400
Message-ID: <4C1A57AE.9080706@caviumnetworks.com>
Date: Thu, 17 Jun 2010 10:13:18 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jesper Nilsson <jesper@jni.nu>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: MIPS: return after handling coprocessor 2 exception
References: <20100617132554.GB24162@jni.nu>
In-Reply-To: <20100617132554.GB24162@jni.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2010 17:13:18.0873 (UTC) FILETIME=[619F8090:01CB0E40]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 06:25 AM, Jesper Nilsson wrote:
> Breaking here dropped us to the default code which always sends
> a SIGILL to the current process, no matter what the CU2 notifier says.
>
> Signed-off-by: Jesper Nilsson<jesper@jni.nu>
> ---
>   traps.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
> index 8bdd6a6..8527808 100644
> --- a/arch/mips/kernel/traps.c
> +++ b/arch/mips/kernel/traps.c
> @@ -976,7 +976,7 @@ asmlinkage void do_cpu(struct pt_regs *regs)
>
>   	case 2:
>   		raw_notifier_call_chain(&cu2_chain, CU2_EXCEPTION, regs);
> -		break;
> +		return;
>

What happens when the call chain is empty, and the proper action *is* 
SIGILL?

David Daney
