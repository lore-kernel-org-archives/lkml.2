Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab1CZNYH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 09:24:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63835 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab1CZNYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 09:24:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dOVFlv5GH1BbHnZ3HvSuq4S32XsmbGC8kyD5Pk224Cw1fsKcJ4IqZElPdZ5lZF56Cx
         3HHJ+bKZtpfFl93g417JiSxedvWtT/GZNrvfUfSB6/t1x/n0Kbh1UPPVPDA0TLAruVi+
         +/1q4yOfzIfxzkeGJl4Wh2z733Czq66p6D038=
Date: Sat, 26 Mar 2011 14:23:48 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH V12 2/4] ptp: Added a clock that uses the eTSEC found
 on the MPC85xx.
Message-ID: <20110326132348.GB23260@riccoc20.at.omicron.at>
References: <cover.1298878618.git.richard.cochran@omicron.at>
 <aa97e94c82ebd8953d83b53f64cbfef66c81b7be.1298878618.git.richard.cochran@omicron.at>
 <1300915804.848.40.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300915804.848.40.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 02:30:04PM -0700, John Stultz wrote:
> On Mon, 2011-02-28 at 08:57 +0100, Richard Cochran wrote:
> > +/*
> > + * Register access functions
> > + */
> 
> So what are the locking rules on the functions below? I assume the
> etsects->lock needs to be held prior to calling, so that should be made
> explicit in a comment.

Yes, you are right. I'll add comments.

> > +	gfar_write(&etsects->regs->tmr_ctrl,   tmr_ctrl);
> > +	gfar_write(&etsects->regs->tmr_add,    etsects->tmr_add);
> > +	gfar_write(&etsects->regs->tmr_prsc,   etsects->tmr_prsc);
> > +	gfar_write(&etsects->regs->tmr_fiper1, etsects->tmr_fiper1);
> > +	gfar_write(&etsects->regs->tmr_fiper2, etsects->tmr_fiper2);
> > +	set_alarm(etsects);
> > +	gfar_write(&etsects->regs->tmr_ctrl,   tmr_ctrl|FS|RTPE|TE);
> 
> Does any of the above need a lock should an irq land in the middle of
> the writes?

Since these interrupts first must be enabled, I think it unlikely that
an IRQ could occur. However, it can't hurt to add the lock, either.

Thanks,

Richard
