Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab1CQRLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:11:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36872 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1CQRLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:11:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iUH426JzDs2WrFahyfBQFki0fKIEg0oY3lEhkRLhDi0OBfkopQr7y+mgwKzD9OFs5O
         P/MJzOer1HRStmPj9B0tlLQ/Ior4uNnM/2Syt0V9dTc97tbN4yo1UHw19OxfO/6Fmf6h
         1qpkDkgoqIqBp+gM2WDdvJ3cT+vt/Llp5C7cs=
Subject: Re: um: WARNING: at kernel/futex.c:786 __unqueue_futex
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        laijs@cn.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net, dvhart@linux.intel.com
In-Reply-To: <1300380909.16880.264.camel@gandalf.stny.rr.com>
References: <AANLkTi=e+tM-WTerLmkZfLTQqKCLsJHVBgQ5sj+TMjc4@mail.gmail.com>
	 <1300370936.16880.96.camel@gandalf.stny.rr.com>
	 <AANLkTi=Z_yYkdwzO7TMs7nSMOXR9wn_7BxtKjOKgS5HL@mail.gmail.com>
	 <1300380909.16880.264.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 18:02:20 +0100
Message-ID: <1300381340.6315.323.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 17 mars 2011 à 12:55 -0400, Steven Rostedt a écrit :
> Here, test this patch. I'm in the process of committing it now.
> It will be two patches, one for the WARN_ON_SMP() change, the other for
> the futex change.
> 
> -- Steve
> 
> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index c2c9ba0..25f1e9e 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -168,7 +168,7 @@ extern void warn_slowpath_null(const char *file, const int line);
>  #ifdef CONFIG_SMP
>  # define WARN_ON_SMP(x)			WARN_ON(x)
>  #else
> -# define WARN_ON_SMP(x)			do { } while (0)
> +# define WARN_ON_SMP(x)			({0;})
>  #endif
>  

You meant :

# define WARN_ON_SMP(x)			({x;})

or

# define WARN_ON_SMP(x)	  do { } while (x, 0)

?


