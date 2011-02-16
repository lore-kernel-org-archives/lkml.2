Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab1BPXQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 18:16:06 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42394 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab1BPXQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 18:16:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mTDQdkgMvVi3HHr6jH3SmSPbSVnKrC3BN2ei8Zmqv5CHh+hi6V/EAjwOu9a/7hvLRz
         JYlfL8e7IrzlLYgZBJ555RBdEP1H1/Toc8BuSZUzp0Q8C8T2RgTEPSY0cKFAsLHmXRMT
         Y77Dn6cLmqDi+JxPvLTUvwm5HPLe6f7JJSuQU=
Date: Thu, 17 Feb 2011 00:15:56 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, numa: exit early on numa_reset_distance()
Message-ID: <20110216231556.GG29600@atj.dyndns.org>
References: <4D5C3A0F.3080107@kernel.org>
 <20110216223943.GA29600@atj.dyndns.org>
 <4D5C5909.4020405@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5C5909.4020405@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 03:08:57PM -0800, Yinghai Lu wrote:
> > But please move the existing numa_distance = NULL before the
> > conditional and do if (!numa_distance_cnt) return;
> 
> confused. Do you mean this one ?

Heh, I was confused.

> @@ -371,11 +371,13 @@ static void __init numa_reset_distance(v
>  {
>  	size_t size;
>  
> -	size = numa_distance_cnt * sizeof(numa_distance[0]);
> -	memblock_x86_free_range(__pa(numa_distance),
> -				__pa(numa_distance) + size);
> +	if (numa_distance_cnt) {
> +		size = numa_distance_cnt * sizeof(numa_distance[0]);
> +		memblock_x86_free_range(__pa(numa_distance),
> +					__pa(numa_distance) + size);
> +		numa_distance_cnt = 0;
> +	}
>  	numa_distance = NULL;
> -	numa_distance_cnt = 0;

But I like this one better.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
