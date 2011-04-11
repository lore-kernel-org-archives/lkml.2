Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab1DKMjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 08:39:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38940 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab1DKMjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 08:39:21 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=wom5GMh1gUkA:10 a=FN-3_s8mWFMA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=UPm3pfgAAAAA:8 a=fxJcL_dCAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=xGm0K_yc99O9d1z3KkoA:9 a=2sjND39uR9uwjG1M6eEA:7 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=mOio7EKfaG4A:10 a=2eKvNQJKnqYA:10 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Mon, 11 Apr 2011 07:39:19 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] uts: Set default hostname to "localhost", rather
 than "(none)"
Message-ID: <20110411123919.GA17405@hallyn.com>
References: <20110411050155.GA2507@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110411050155.GA2507@feather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Josh Triplett (josh@joshtriplett.org):
> The "hostname" tool falls back to setting the hostname to "localhost" if
> /etc/hostname does not exist.  Distribution init scripts have the same
> fallback.  However, if userspace never calls sethostname, such as when
> booting with init=/bin/sh, or otherwise booting a minimal system without
> the usual init scripts, the default hostname of "(none)" remains,
> unhelpfully appearing in various places such as prompts
> ("root@(none):~#") and logs.  Furthrmore, "(none)" doesn't typically
> resolve to anything useful, while "localhost" does.
> 
> Change the default hostname to "localhost".  This removes the need for
> the standard fallback, provides a useful default for systems that never
> call sethostname, and makes minimal systems that much more useful with
> less configuration.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Seems good to me.  I'd have no idea if there were valid reasons to object
to such a thing so my ack means nothing, but

Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>

thanks,
-serge

> ---
> 
> Looked at "(none)" one too many times, and figured I ought to do
> something about it.
> 
> Resending, and adding CCs for networking and UTS.
> 
>  include/linux/uts.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/uts.h b/include/linux/uts.h
> index 73eb1ed..610bec2 100644
> --- a/include/linux/uts.h
> +++ b/include/linux/uts.h
> @@ -9,7 +9,7 @@
>  #endif
>  
>  #ifndef UTS_NODENAME
> -#define UTS_NODENAME "(none)"	/* set by sethostname() */
> +#define UTS_NODENAME "localhost"	/* set by sethostname() */
>  #endif
>  
>  #ifndef UTS_DOMAINNAME
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
