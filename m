Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2JELY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 07:24:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:22285 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab2JELY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 07:24:26 -0400
X-IronPort-AV: E=Sophos;i="4.80,541,1344211200"; 
   d="scan'208";a="40251794"
Message-ID: <506EC363.9050201@citrix.com>
Date: Fri, 5 Oct 2012 12:24:19 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: allow tracing of functions in arch/x86/kernel/rtc.c
References: <1349435895-21269-1-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1349435895-21269-1-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/12 12:18, David Vrabel wrote:
> Move native_read_tsc() to tsc.c to allow profiling to be re-enabled
> for rtc.c.

Sorry, dropped the EXPORT_SYMBOL() by mistake.  I'll fix this and repost.

David

> diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
> index af6db6e..8ab7c62 100644
> --- a/arch/x86/kernel/rtc.c
> +++ b/arch/x86/kernel/rtc.c
> @@ -195,12 +195,6 @@ void read_persistent_clock(struct timespec *ts)
>  	ts->tv_nsec = 0;
>  }
>  
> -unsigned long long native_read_tsc(void)
> -{
> -	return __native_read_tsc();
> -}
> -EXPORT_SYMBOL(native_read_tsc);
> -
>  
>  static struct resource rtc_resources[] = {
>  	[0] = {
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index cfa5d4f..15e190a 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -77,6 +77,11 @@ unsigned long long
>  sched_clock(void) __attribute__((alias("native_sched_clock")));
>  #endif
>  
> +unsigned long long native_read_tsc(void)
> +{
> +	return __native_read_tsc();
> +}
> +
>  int check_tsc_unstable(void)
>  {
>  	return tsc_unstable;

