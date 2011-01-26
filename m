Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab1AZM3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:29:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46127 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab1AZM3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:29:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O8NW2+1KnX9+6hHwjuvjoSMo2ECmW8m8mHqCqFwT5YEix5YURqL5Qi4Tn1jaHdjs1N
         ynwS3VFX3DJwgFOidOwUdoVl/yl/m8X86YXiSOnrdIjcK946q+hKgs6Idj3yMgA9IHMo
         am6R5qWxWxrC1Xz6y0jp4ZRSJZtj4XOl28ByM=
Date: Wed, 26 Jan 2011 20:29:00 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Untangle cpu-load and timekeeping code
Message-ID: <20110126122900.GA8387@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <new-submission>
 <tip-18a57c3b43781ea83c3bb21c3add84ba890d5fb3@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-18a57c3b43781ea83c3bb21c3add84ba890d5fb3@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 12:14:43PM +0000, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  18a57c3b43781ea83c3bb21c3add84ba890d5fb3
> Gitweb:     http://git.kernel.org/tip/18a57c3b43781ea83c3bb21c3add84ba890d5fb3
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Tue, 25 Jan 2011 11:30:35 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 26 Jan 2011 12:33:23 +0100
> 
> sched: Untangle cpu-load and timekeeping code
> 
> Remove the calc_global_load() call from the timekeeping code and make
> it local to the scheduler.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
> +static void calc_global_load(unsigned long __data)
>  {
>  	long active;
>  
> -	calc_global_nohz(ticks);
> +	calc_global_nohz();
>  
>  	if (time_before(jiffies, calc_load_update + 10))
>  		return;

We should not do this checking any more. In normal case,
it will always return false.
If it indeed returns true for some reason, we will lose the
timer forever.

Thanks,
Yong
