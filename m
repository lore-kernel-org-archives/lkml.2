Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab1HYTG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:06:58 -0400
Received: from mail.noc.grnet.gr ([83.212.9.5]:37129 "EHLO mail.noc.grnet.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306Ab1HYTG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:06:57 -0400
X-Greylist: delayed 635 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Aug 2011 15:06:56 EDT
Date: Thu, 25 Aug 2011 21:56:16 +0300
From: Faidon Liambotis <paravoid@debian.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        john stultz <johnstul@us.ibm.com>, Willy Tarreau <w@1wt.eu>,
        MINOURA Makoto <minoura@valinux.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        stable@kernel.org, seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es
Subject: Re: 2.6.32.21 - uptime related crashes?
Message-ID: <20110825185616.GA17078@faidon.noc.grnet.gr>
References: <1310434819.30337.21.camel@work-vm>
 <20110712041938.GO27254@1wt.eu>
 <1310690138.3367.61.camel@work-vm>
 <1310724097.2586.296.camel@twins>
 <1310752795.2945.4.camel@work-vm>
 <20110721072256.GE9216@elte.hu>
 <1311251098.29152.130.camel@twins>
 <20110721125008.GF11246@pcnci.linuxbox.cz>
 <1311252799.29152.147.camel@twins>
 <20110721184524.GB381@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721184524.GB381@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 08:45:25PM +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, 2011-07-21 at 14:50 +0200, Nikola Ciprich wrote:
> > > thanks for the patch! I'll put this on our testing boxes...
> > 
> > With a patch that frobs the starting value close to overflowing I hope,
> > otherwise we'll not hear from you in like 7 months ;-)
> > 
> > > Are You going to push this upstream so we can ask Greg to push this to
> > > -stable? 
> > 
> > Yeah, I think we want to commit this with a -stable tag, Ingo?
> 
> yeah - and we also want a Reported-by tag and an explanation of how 
> it can crash and why it matters in practice. I can then stick it into 
> the urgent branch for Linus. (probably will only hit upstream in the 
> merge window though.)

Has this been pushed or has the problem been solved somehow? Time is
against us on this bug as more boxes will crash as they reach 200 days
of uptime...

In any case, feel free to use me as a Reported-by, my full report of the
problem being <20110430173905.GA25641@tty.gr>.

FWIW and if I understand correctly, my symptoms were caused by *two*
different bugs:
a) the 54 bits wraparound at 208 days that Peter fixed above,
b) a kernel crash at ~215 days related to RT tasks, fixed by
305e6835e05513406fa12820e40e4a8ecb63743c (already in -stable).

Regards,
Faidon
