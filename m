Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab0DPO7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:59:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38456 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab0DPO7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:59:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gj2pAUg2jCU8nb7h3ZWJ2wRFTOR8K2CmINah+2LpFun7CBYyYsWre/PZoFdzYfyE6V
         LTccShhGU+a9Tu20A2vaF9VIaHAMznYeUkL6nH2LoE9IoEVyvowNd1jfcBYx1xzEFsyg
         j62NyBUmKnX02seL7n0junqs/QYd/5FpfoNYc=
Date: Fri, 16 Apr 2010 16:59:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Don Zickus <dzickus@redhat.com>,
       mingo@elte.hu, aris@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100416145920.GE5162@nowhere>
References: <1271366710-17468-1-git-send-email-dzickus@redhat.com> <20100416014712.GC15570@nowhere> <20100416143232.GA5540@lenovo> <20100416144616.GC5162@nowhere> <1271429591.4807.2385.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271429591.4807.2385.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 04:53:11PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-04-16 at 16:46 +0200, Frederic Weisbecker wrote:
> > > > May be have an arch spin lock there to update your cpu mask safely.
> > > > 
> > > 
> > > Hmm, this is NMI handler path so from what we protect this per-cpu data?
> > > Do I miss something? /me confused
> > 
> > 
> > The cpu mask is not per cpu here, this is a shared bitmap, so you
> > can race against other cpus NMIs.
> > 
> > That said, as I suggested, having a per cpu var that we set when we
> > warned would be much better than a spinlock here. 
> 
> Every time you think NMI and spinlock think FAIL.


In fact I was first inspired by the x86 nmi watchdog handler
that does this spinlock to protect cpumask, but realize just
after my FAIL ;-)

