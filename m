Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab1ANNNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 08:13:18 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40793 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757302Ab1ANNNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 08:13:12 -0500
X-Sasl-enc: lL1yCkUA6OaSBRXRqJRRiikW+JEuO/KA/n4kjavYYjkz 1295010791
Message-ID: <4D304BE6.9070200@fastmail.fm>
Date: Fri, 14 Jan 2011 13:13:10 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@st.com>
CC: linux-kernel@vger.kernel.org, arjan@linux.intel.com
Subject: Re: [PATCH resend] kernel/async.c: fixing compilation warnings
References: <1295005980-12297-1-git-send-email-viresh.kumar@st.com>
In-Reply-To: <1295005980-12297-1-git-send-email-viresh.kumar@st.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc Arjan van de Ven]
On 14/01/2011 11:53, Viresh Kumar wrote:
> This patch fixes following compilation warnings:
> 270:10: warning: ‘starttime.tv64’ may be used uninitialized in this function
> 122:10: warning: ‘calltime.tv64’ may be used uninitialized in this function
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Looks good to me

Reviewed-by: Jack Stone <jwjstone@fastmail.fm>
> ---
>  kernel/async.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/async.c b/kernel/async.c
> index cd9dbb9..3ff777b 100644
> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -119,7 +119,7 @@ static void async_run_entry_fn(struct work_struct *work)
>  	struct async_entry *entry =
>  		container_of(work, struct async_entry, work);
>  	unsigned long flags;
> -	ktime_t calltime, delta, rettime;
> +	ktime_t uninitialized_var(calltime), delta, rettime;
>  
>  	/* 1) move self to the running queue */
>  	spin_lock_irqsave(&async_lock, flags);
> @@ -267,7 +267,7 @@ EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
>  void async_synchronize_cookie_domain(async_cookie_t cookie,
>  				     struct list_head *running)
>  {
> -	ktime_t starttime, delta, endtime;
> +	ktime_t uninitialized_var(starttime), delta, endtime;
>  
>  	if (initcall_debug && system_state == SYSTEM_BOOTING) {
>  		printk("async_waiting @ %i\n", task_pid_nr(current));

