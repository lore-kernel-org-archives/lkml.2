Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab2C1VIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:08:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758338Ab2C1VIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:08:37 -0400
Date: Wed, 28 Mar 2012 14:08:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysrq: Use SEND_SIG_FORCED instead of force_sig()
Message-Id: <20120328140835.38e1f03f.akpm@linux-foundation.org>
In-Reply-To: <20120328205254.GA6930@redhat.com>
References: <20120324110024.GA14067@lizard>
	<20120326154303.86126785.akpm@linux-foundation.org>
	<20120328205254.GA6930@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 22:52:54 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 03/26, Andrew Morton wrote:
> >
> > > --- a/drivers/tty/sysrq.c
> > > +++ b/drivers/tty/sysrq.c
> > > @@ -329,7 +329,7 @@ static void send_sig_all(int sig)
> > >  		if (is_global_init(p))
> > >  			continue;
> > >
> > > -		force_sig(sig, p);
> > > +		do_send_sig_info(sig, SEND_SIG_FORCED, p, true);
> > >  	}
> > >  	read_unlock(&tasklist_lock);
> > >  }
> >
> > It's unclear how serious this race is (I'm guessing "not very"),
> 
> Well yes, I think that the problems are not very serious.
> 
> > but
> > this patch looks like 3.3 material anyway, yes?
> 
> No, this depends on 629d362b9950166c6fac2aa8425db34d824bb043
> "signal: give SEND_SIG_FORCED more power to beat SIGNAL_UNKILLABLE".

oop, I meant "this patch looks like 3.4 material"?
