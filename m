Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab1IMTCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 15:02:33 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:60539 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932092Ab1IMTCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 15:02:32 -0400
Message-ID: <4E6FA8AE.5010308@xenotime.net>
Date: Tue, 13 Sep 2011 12:02:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Gilad Ben-Yossef <gilad@benyossef.com>
CC: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH Resend][Trivial] Match on_each_cpu behaviour on UP to
 SMP
References: <1315465029-4203-1-git-send-email-gilad@benyossef.com>
In-Reply-To: <1315465029-4203-1-git-send-email-gilad@benyossef.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/11 23:57, Gilad Ben-Yossef wrote:
> The comment in the SMP implementation of on_each_cpu says:
>  "May be used during early boot while
>   early_boot_irqs_disabled is set.  Use local_irq_save/restore() instead
>   of local_irq_disable/enable()."
> 
> but the existing UP macro version uses local_irq_disable/enable().
> 
> Do the safe thing - make the UP version match the SMP one.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> CC: Jiri Kosina <trivial@kernel.org>
> ---
>  include/linux/smp.h |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/smp.h b/include/linux/smp.h
> index 8cc38d3..7c9b9d4 100644
> --- a/include/linux/smp.h
> +++ b/include/linux/smp.h
> @@ -127,9 +127,10 @@ static inline int up_smp_call_function(smp_call_func_t func, void *info)
>  			(up_smp_call_function(func, info))
>  #define on_each_cpu(func,info,wait)		\
>  	({					\
> -		local_irq_disable();		\
> +		unsigned long __flags;		\
> +		local_irq_save(__flags);	\
>  		func(info);			\
> -		local_irq_enable();		\
> +		local_irq_retore(__flags);	\

You tested that?          ^^^^^^


>  		0;				\
>  	})
>  static inline void smp_send_reschedule(int cpu) { }


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
