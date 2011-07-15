Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab1GOSEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:04:01 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57550 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab1GOSD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:03:59 -0400
Subject: Re: 2.6.32.21 - uptime related crashes?
From: john stultz <johnstul@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
        "MINOURA Makoto / ?$BL'1: ?$B??" <minoura@valinux.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        seto.hidetoshi@jp.fujitsu.com,
        =?ISO-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es
In-Reply-To: <1310724161.2586.297.camel@twins>
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
	 <20110428183434.GG30645@1wt.eu> <20110429100200.GB23293@pcnci.linuxbox.cz>
	 <20110430093605.GA10529@1wt.eu> <20110430173905.GA25641@tty.gr>
	 <BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com>
	 <20110705231515.95bc758f.akpm@linux-foundation.org>
	 <kk5d3hgi9eh.fsf@brer.local.valinux.co.jp>
	 <1310434819.30337.21.camel@work-vm>  <20110712041938.GO27254@1wt.eu>
	 <1310690138.3367.61.camel@work-vm>  <1310718603.2586.278.camel@twins>
	 <1310724161.2586.297.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 11:03:27 -0700
Message-ID: <1310753007.2945.7.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 12:02 +0200, Peter Zijlstra wrote:
> On Fri, 2011-07-15 at 10:30 +0200, Peter Zijlstra wrote:
> > On Thu, 2011-07-14 at 17:35 -0700, john stultz wrote:
> > > 
> > > Peter/Ingo: Can you take a look at the above and let me know if you find
> > > it too disagreeable? 
> > 
> > I'm not quite sure of the calling conditions of set_cyc2ns_scale(), but
> > there's two sites in there that do:
> > 
> > +       local_irq_save(flags);
> > 
> > +               data = kmalloc(sizeof(*data), GFP_KERNEL);
> > 
> > +       local_irq_restore(flags);
> > 
> > Clearly that's not going to work well at all.
> 
> Furthermore there is a distinct lack of error handling there, it assumes
> the allocation always succeeds.

Yes, both of those issues are embarrassing. Thanks for pointing them
out. I'll take another swing at it.

thanks
-john


