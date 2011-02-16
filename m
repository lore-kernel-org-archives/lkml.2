Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab1BPWjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:39:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56733 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1BPWjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:39:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IMtrmCkOkRCL7eDwwghcGA08VWH219SNvlzK4geQmlxBYUnyr9ohIQsP/fe+QU4FOo
         5CWNAQx5p9w6Hce/s9MzSFnwtgLZPlnfoIbCtB454+AeZL/pPXVhJfN92wSu0EUOdH1B
         Udr3d4mKsPNMC1W8YF63L9kTwCkxb4s3QI54k=
Date: Wed, 16 Feb 2011 23:39:43 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, numa: exit early on numa_reset_distance()
Message-ID: <20110216223943.GA29600@atj.dyndns.org>
References: <4D5C3A0F.3080107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5C3A0F.3080107@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 12:56:47PM -0800, Yinghai Lu wrote:
> 
> Do not call __pa(numa_distance), if it is not allocated before.
> 
> it will get BUG_ON if VIRTUAL_DEBUG is on.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Thanks for spotting this.

> Index: linux-2.6/arch/x86/mm/numa_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/numa_64.c
> +++ linux-2.6/arch/x86/mm/numa_64.c
> @@ -371,6 +371,12 @@ static void __init numa_reset_distance(v
>  {
>  	size_t size;
>  
> +	if (!numa_distance_cnt) {
> +		numa_distance = NULL;
> +
> +		return;
> +	}
> +

But please move the existing numa_distance = NULL before the
conditional and do if (!numa_distance_cnt) return;

Thanks.

--
tejun
