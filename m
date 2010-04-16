Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab0DPOyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:54:51 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:41843 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0DPOyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:54:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jeyPZX0YPJhP+oY+ZTWD64swyaiUyhaNt0bkWpZQRu4dAsJr54cnvKc0Ry/1Wn21Ku
         tCBlEjWDuu0ygsDvqAHDMXM5q9opjbiUZOmoukjfIJtee/fZ0kuw5k6N2XY9tRcXGJEE
         fw+R53eNV2zL61og2RW55WnZvQVNNsW2FfnQ0=
Date: Fri, 16 Apr 2010 18:54:44 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, mingo@elte.hu, peterz@infradead.org,
       aris@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100416145444.GB5540@lenovo>
References: <1271366710-17468-1-git-send-email-dzickus@redhat.com> <20100416014712.GC15570@nowhere> <20100416143232.GA5540@lenovo> <20100416144616.GC5162@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100416144616.GC5162@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 04:46:17PM +0200, Frederic Weisbecker wrote:
...
> > > > +		if (hardlockup_panic)
> > > > +			panic("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
> > > > +		else
> > > > +			WARN(1, "Watchdog detected hard LOCKUP on cpu %d", this_cpu);
> > > > +
> > > > +		cpumask_set_cpu(this_cpu, to_cpumask(hardlockup_mask));
> > > 
> > > 
> > > 
> > > May be have an arch spin lock there to update your cpu mask safely.
> > > 
> > 
> > Hmm, this is NMI handler path so from what we protect this per-cpu data?
> > Do I miss something? /me confused
> 
> 
> The cpu mask is not per cpu here, this is a shared bitmap, so you
> can race against other cpus NMIs.
> 
> That said, as I suggested, having a per cpu var that we set when we
> warned would be much better than a spinlock here.
> 

yeah, saw DECLARE_BITMAP but read it as DEFINE_PER_CPU for some reason.
having any spinlock in irq handler is really under suspicious.

	-- Cyrill
