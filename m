Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab2JKAuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:50:11 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45377 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab2JKAuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:50:09 -0400
Date: Wed, 10 Oct 2012 17:50:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: Advise most users not to enable RCU user mode
Message-ID: <20121011005004.GL2495@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1349912908-11814-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349912908-11814-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101100-7282-0000-0000-00000DCD67C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 01:48:28AM +0200, Frederic Weisbecker wrote:
> Discourage distros from enabling CONFIG_RCU_USER_QS
> because it brings overhead for no benefits yet.
> 
> It's not a useful feature on its own until we can
> fully run an adaptive tickless kernel.

Queued, hopefully for 3.7, thank you!

							Thanx, Paul

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  init/Kconfig |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index c26b8a1..89093e1 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -451,6 +451,12 @@ config RCU_USER_QS
>  	  excluded from the global RCU state machine and thus doesn't
>  	  to keep the timer tick on for RCU.
> 
> +	  Unless you want to hack and help the development of the full
> +	  tickless feature, you shouldn't enable this option. It adds
> +	  unnecessary overhead.
> +
> +	  If unsure say N
> +
>  config RCU_USER_QS_FORCE
>  	bool "Force userspace extended QS by default"
>  	depends on RCU_USER_QS
> @@ -459,6 +465,12 @@ config RCU_USER_QS_FORCE
>  	  test this feature that treats userspace as an extended quiescent
>  	  state until we have a real user like a full adaptive nohz option.
> 
> +	  Unless you want to hack and help the development of the full
> +	  tickless feature, you shouldn't enable this option. It adds
> +	  unnecessary overhead.
> +
> +	  If unsure say N
> +
>  config RCU_FANOUT
>  	int "Tree-based hierarchical RCU fanout value"
>  	range 2 64 if 64BIT
> -- 
> 1.7.5.4
> 

