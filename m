Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0EPKqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 06:46:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:5823 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab0EPKqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 06:46:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=niYRf5HsHYxDgJz0GkBJ5m4Uvz03KomKMowh8JWCWabO06HgT3zzf9CStpMo/j7l6G
         JMOtFmOBJWQ95IegiZNxn2hkCXfvlzw+6jBDQCQPDwvBjtERWaBnLquL/68sSqShr8p3
         S9Tm2LytKPF6W1uo3yMPQ2Ku38sqYUrQuM6Cg=
Date: Sun, 16 May 2010 14:46:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH] lktdm: Bring support for hardlockup, softlockup and
	hung task crashes
Message-ID: <20100516104603.GF5133@lenovo>
References: <1273988391-16401-1-git-send-regression-fweisbec@gmail.com> <20100516093636.GE5133@lenovo> <20100516103506.GD5306@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100516103506.GD5306@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 12:35:08PM +0200, Frederic Weisbecker wrote:
...
> > Looks good to me. Btw perhaps we may simplify it a bit:
> > 
> > 	case HARDLOCKUP:
> > 		local_irq_disable();
> > 	case SOFTLOCKUP:
> > 		preempt_disable();
> > 		for (;;)
> > 			cpu_relax();
> > 		break;
> > 
> > since it'll save a few bytes. What do you think? Did I miss
> > something?
> 
> 
> It would make the code a bit less clear in that people
> might stick on the reason to disable preemption after disabling
> irq, especially with a code that already does something rather
> unusual ;)
> 

ok, convinced

	-- Cyrill
