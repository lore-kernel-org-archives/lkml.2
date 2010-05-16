Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0EPKfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 06:35:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60826 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab0EPKfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 06:35:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SLiGS6FOGLwBthPNwSlZMuKsINWfsIpYehJ2MkPPWqahOH8i7kmRLparPnR2flMS5b
         cpJkfmdL1BYybETY+R3vV0VN31ogCuafbeDeY+ad8DNhzTPRFvSdUjI5n0Ik7xS58O77
         ommQAtoWZu+T+J3wO0Npc6fmZKta8gykTgUwY=
Date: Sun, 16 May 2010 12:35:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH] lktdm: Bring support for hardlockup, softlockup and
	hung task crashes
Message-ID: <20100516103506.GD5306@nowhere>
References: <1273988391-16401-1-git-send-regression-fweisbec@gmail.com> <20100516093636.GE5133@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100516093636.GE5133@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 01:36:36PM +0400, Cyrill Gorcunov wrote:
> On Sun, May 16, 2010 at 07:39:51AM +0200, Frederic Weisbecker wrote:
> ...  
> >  static struct jprobe lkdtm;
> > @@ -320,6 +326,20 @@ static void lkdtm_do_action(enum ctype which)
> >  		memset(data, 0x78, len);
> >  		break;
> >  	}
> > +	case SOFTLOCKUP:
> > +		preempt_disable();
> > +		for (;;)
> > +			cpu_relax();
> > +		break;
> > +	case HARDLOCKUP:
> > +		local_irq_disable();
> > +		for (;;)
> > +			cpu_relax();
> > +		break;
> > +	case HUNG_TASK:
> > +		set_current_state(TASK_UNINTERRUPTIBLE);
> > +		schedule();
> > +		break;
> >  	case NONE:
> >  	default:
> >  		break;
> 
> Looks good to me. Btw perhaps we may simplify it a bit:
> 
> 	case HARDLOCKUP:
> 		local_irq_disable();
> 	case SOFTLOCKUP:
> 		preempt_disable();
> 		for (;;)
> 			cpu_relax();
> 		break;
> 
> since it'll save a few bytes. What do you think? Did I miss
> something?


It would make the code a bit less clear in that people
might stick on the reason to disable preemption after disabling
irq, especially with a code that already does something rather
unusual ;)

