Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab0ILNGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 09:06:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59539 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0ILNGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 09:06:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u4Uf/BPeN1io2Z3dNeP43VqFMncdfcZSzQMaeP6cYS0WCjdjXkVAONvuBWO3EmgJ9E
         JMbSWwQPF+G2KEFdX6ksWsGtm3Q42jaRcmfvr02AgKjLprlNRMOd8T81MIEiTYVdxT26
         XIEAMeGl6lx+RkQM6953u2mjiGAn4gsi82+6E=
Date: Sun, 12 Sep 2010 15:06:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Corentin Chary <corentincj@iksaif.net>
Subject: Re: EeePC 900 reboots/hangs when using using perf -a -f -g
Message-ID: <20100912130637.GB5342@nowhere>
References: <20100912102854.GA7359@sucs.org> <1284289027.2251.95.camel@laptop> <20100912112105.GA28420@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100912112105.GA28420@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 12:21:05PM +0100, Sitsofe Wheeler wrote:
> On Sun, Sep 12, 2010 at 12:57:07PM +0200, Peter Zijlstra wrote:
> > 
> > Bisect it?
> 
> .35 shows the same issue (although I didn't recompile my perf binary). I
> don't know if this is a regression - it might always have been there...


Testing with a software event like page faults will test if it's related
to hardware events only or some of them.
For example if it doesn't happen in fault events, then let's try with some
others, just to see if we can narrow down to some particular events.


If it happens on faults it will be easier to debug because software events
don't happen in NMI (at least not the faults), so enabling RCU stalls checks
there will probably success to trigger a backtrace. Perhaps you can profile
only one CPU for that (-C 1, eeepc 900 are SMT, right?), so that there is
a free CPU to notice the stall and trigger the backtrace through remote NMIs.

