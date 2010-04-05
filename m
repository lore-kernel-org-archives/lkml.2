Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab0DEUwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:52:31 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45643 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab0DEUwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:52:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gqJ2fktvAVD30UiCirDbj1hOGZswfQeG9Pjmmb2JoU+WwAhXSFxHSy2nIkVVe76XE+
         R1Lzum1sc64iQUm8qvPuZMqKSdC5kPxJdImjNWT5iTHAwz3G+CnEmendg8NvR6pSVl1M
         wFlIg8a70JwOkjVFRKq6bc9+ysIXLxpU+dJGw=
Date: Mon, 5 Apr 2010 13:52:13 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Adam Belay <abelay@novell.com>, Len Brown <len.brown@intel.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
Message-ID: <20100405205213.GA4576@core.coreip.homeip.net>
References: <20100403223328.GA4507@comet.dominikbrodowski.net>
 <20100403235326.GA23445@core.coreip.homeip.net>
 <20100404104708.GA5922@comet.dominikbrodowski.net>
 <4BB95C33.1050706@linux.intel.com>
 <20100405204143.GB23159@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100405204143.GB23159@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 10:41:43PM +0200, Dominik Brodowski wrote:
> On Sun, Apr 04, 2010 at 08:42:43PM -0700, Arjan van de Ven wrote:
> > On 4/4/2010 3:47, Dominik Brodowski wrote:
> > >Hey,
> > >
> > >On Sat, Apr 03, 2010 at 04:53:26PM -0700, Dmitry Torokhov wrote:
> > >>On Sun, Apr 04, 2010 at 12:33:28AM +0200, Dominik Brodowski wrote:
> > >>>
> > >>>4) SynPS/2 touchpad:
> > >>>Why does moving the touchpad lead to sooo many IRQs? I can't look as fast
> > >>>as the mouse pointer seems to get new data:
> > >>>   62,5% (473,1)<interrupt>  : PS/2 keyboard/mouse/touchpad
> > >>>
> > >>
> > >>80 pps @ 6 bytes/packet = 480 interrupts/sec.
> > >>
> > >>You can try using psmouse.rate=40 to limit it to 40 pps which should
> > >>bring it to the rate of standard PS/2 mouse at the expense of
> > >>sensitivity...
> > >
> > >as a sidenote: if we know -- like here -- that the next IRQ will be issued
> > >soon, in approximately 1.75 ms (well, at least on my system), might it make
> > >sense to make tick_nohz_get_sleep_length() smarter to know about this?
> > 
> > yes and no.
> > 
> > if you are very sure (95%+ or so) then absolutely it needs to know about this
> > so that the C state selection code can make a better decision.
> > Right now it tries to look at history to guess this delay.
> > 
> > Unfortunately we do not currently have such a concept in the code to make this
> > work... but it'd be really nice to have.
> 
> Dmitry, are we "very sure" in this touchpad case?
> 

Psmouse driver tries to not rely on any timing data really... But yes,
we do expect the next interrupt to arrive "shortly" and I guess the
driver could do some data gathering to collect average time between
interrupts. The question is - is it worth it?

-- 
Dmitry
