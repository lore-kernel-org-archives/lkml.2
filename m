Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562Ab2BOOwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:52:40 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37274 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759406Ab2BOOwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:52:30 -0500
Date: Wed, 15 Feb 2012 14:52:25 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
Message-ID: <20120215145225.GA21448@srcf.ucam.org>
References: <1317308372-6810-1-git-send-email-mjg@redhat.com>
 <alpine.LFD.2.02.1202151537500.2794@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1202151537500.2794@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 03:40:24PM +0100, Thomas Gleixner wrote:
> > +	 * be scheduled. Special case that to avoid actually putting them
> > +	 * to sleep for the duration of the slack.
> > +	 */
> > +	if (rqtp->tv_sec == 0 && rqtp->tv_nsec == 0)
> > +		slack = 0;
> 
> That's pretty pointless. You can simply return 0 here as
> do_nanosleep() will not call the scheduler on an already expired
> timer, which is always true for a relative timer with delta 0.

I'm actually starting to wonder about the applications doing this. We 
default to adding a small amount of slack even if the application has 
done sleep(0), which will mean that the timer hasn't expired at this 
point. Do we then go through the scheduler differently? Are these 
applications actually relying on an invalid assumption?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
