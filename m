Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab2BOQDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:03:00 -0500
Received: from mail.southpole.se ([193.12.106.18]:58734 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2BOQCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:02:55 -0500
Message-ID: <1329320456.2670.86.camel@crucifix>
Subject: Re: [PATCH 21/40] OpenRISC: Don't reimplement force_sigsegv()
From: Jonas Bonn <jonas@southpole.se>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-arch@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, linux@openrisc.net
Date: Wed, 15 Feb 2012 16:40:56 +0100
In-Reply-To: <1329219673-28711-22-git-send-email-matt@console-pimps.org>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
	 <1329219673-28711-22-git-send-email-matt@console-pimps.org>
Organization: South Pole AB
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu2 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 20453-07209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Jonas Bonn <jonas@southpole.se>

...for OpenRISC, all 4 patches (20-23 in this series).

Should I take these in the OpenRISC tree or how did you want to do?

/Jonas

On Tue, 2012-02-14 at 11:40 +0000, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> Instead of open coding the sequence from force_sigsegv() just call
> it. This also fixes a bug because we were modifying ka->sa.sa_handler
> (which is a copy of sighand->action[]), whereas the intention of the
> code was to modify sighand->action[] directly.
> 
> As the original code was working with a copy it had no effect on
> signal delivery.
> 
> Acked-by: Oleg Nesterov <oleg@redhat.com>
> Cc: Jonas Bonn <jonas@southpole.se>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux@lists.openrisc.net
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/openrisc/kernel/signal.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/openrisc/kernel/signal.c b/arch/openrisc/kernel/signal.c
> index 95207ab..53741ba 100644
> --- a/arch/openrisc/kernel/signal.c
> +++ b/arch/openrisc/kernel/signal.c
> @@ -250,9 +250,7 @@ static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
>  	return;
>  
>  give_sigsegv:
> -	if (sig == SIGSEGV)
> -		ka->sa.sa_handler = SIG_DFL;
> -	force_sig(SIGSEGV, current);
> +	force_sigsegv(sig, current);
>  }
>  
>  static inline void

-- 
Jonas Bonn                       South Pole AB
Phone : +46-8-56237100           Anderstorpsvägen 16
Mobile: +46-768-527755           SE-17154 Solna
jonas@southpole.se               www.southpoleconsulting.com





