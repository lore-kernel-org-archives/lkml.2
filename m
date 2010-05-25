Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab0EYTQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 15:16:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024Ab0EYTQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 15:16:00 -0400
Date: Tue, 25 May 2010 12:12:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       arjan@linux.intel.com, tglx@linutronix.de
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] timers: Fix slack calculation really
In-Reply-To: <tip-8e63d7795e30b4091e303cc8c060509bd8eea742@git.kernel.org>
Message-ID: <alpine.LFD.2.00.1005251211470.3689@i5.linux-foundation.org>
References: <tip-8e63d7795e30b4091e303cc8c060509bd8eea742@git.kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 May 2010, tip-bot for Thomas Gleixner wrote:
>  {
> -	unsigned long expires_limit, mask;
> +	unsigned long expires_limit, mask, now;
>  	int bit;
>  
>  	expires_limit = expires;
>  
> -	if (timer->slack > -1)
> +	if (timer->slack >= 0) {
>  		expires_limit = expires + timer->slack;
> -	else if (time_after(expires, jiffies)) /* auto slack: use 0.4% */
> -		expires_limit = expires + (expires - jiffies)/256;
> -
> +	} else {
> +		now = jiffies;

So this works, but I'd really suggest that you actually nest the 
declarations correctly too. 

		Linus
