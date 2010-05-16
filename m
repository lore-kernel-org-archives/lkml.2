Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0EPJgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 05:36:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42201 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab0EPJgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 05:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kS5Yw4BO3y4ElI3EH0oYW5uH1vjNkKwDGeU4DTY+eW+sgbMFiDgOPivDndMH6LCZsW
         IofX7g0i0oLhNmTZIBJlEMFt8oD9vdnQ/w3Ej4f3ut0edv9ZmpOM0ZN3mVcsfKRz5vi0
         rUsiNNy57jio18HPzBewu43cBtazYQ1wUrKzY=
Date: Sun, 16 May 2010 13:36:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH] lktdm: Bring support for hardlockup, softlockup and
	hung task crashes
Message-ID: <20100516093636.GE5133@lenovo>
References: <1273988391-16401-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273988391-16401-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 07:39:51AM +0200, Frederic Weisbecker wrote:
...  
>  static struct jprobe lkdtm;
> @@ -320,6 +326,20 @@ static void lkdtm_do_action(enum ctype which)
>  		memset(data, 0x78, len);
>  		break;
>  	}
> +	case SOFTLOCKUP:
> +		preempt_disable();
> +		for (;;)
> +			cpu_relax();
> +		break;
> +	case HARDLOCKUP:
> +		local_irq_disable();
> +		for (;;)
> +			cpu_relax();
> +		break;
> +	case HUNG_TASK:
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		schedule();
> +		break;
>  	case NONE:
>  	default:
>  		break;

Looks good to me. Btw perhaps we may simplify it a bit:

	case HARDLOCKUP:
		local_irq_disable();
	case SOFTLOCKUP:
		preempt_disable();
		for (;;)
			cpu_relax();
		break;

since it'll save a few bytes. What do you think? Did I miss
something?

	-- Cyrill
