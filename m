Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab2C1VAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:00:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758014Ab2C1VAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:00:39 -0400
Date: Wed, 28 Mar 2012 22:52:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysrq: Use SEND_SIG_FORCED instead of force_sig()
Message-ID: <20120328205254.GA6930@redhat.com>
References: <20120324110024.GA14067@lizard> <20120326154303.86126785.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120326154303.86126785.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26, Andrew Morton wrote:
>
> > --- a/drivers/tty/sysrq.c
> > +++ b/drivers/tty/sysrq.c
> > @@ -329,7 +329,7 @@ static void send_sig_all(int sig)
> >  		if (is_global_init(p))
> >  			continue;
> >
> > -		force_sig(sig, p);
> > +		do_send_sig_info(sig, SEND_SIG_FORCED, p, true);
> >  	}
> >  	read_unlock(&tasklist_lock);
> >  }
>
> It's unclear how serious this race is (I'm guessing "not very"),

Well yes, I think that the problems are not very serious.

> but
> this patch looks like 3.3 material anyway, yes?

No, this depends on 629d362b9950166c6fac2aa8425db34d824bb043
"signal: give SEND_SIG_FORCED more power to beat SIGNAL_UNKILLABLE".

Oleg.

