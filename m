Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab0DEURM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:17:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756456Ab0DEURI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:17:08 -0400
Date: Mon, 5 Apr 2010 16:16:46 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Aristeu Sergio Rozanski Filho <aris@ruivo.org>, mingo@elte.hu,
       peterz@infradead.org, aris@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100405201646.GF15159@redhat.com>
References: <20100323213338.GA29170@redhat.com>
 <20100328024650.GA26522@jake.ruivo.org>
 <20100329182617.GI15159@redhat.com>
 <20100330145238.GG6706@cathedrallabs.org>
 <20100405201111.GF5079@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100405201111.GF5079@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 12:11:11AM +0400, Cyrill Gorcunov wrote:
> On Tue, Mar 30, 2010 at 10:52:38AM -0400, Aristeu Sergio Rozanski Filho wrote:
> > > On Sat, Mar 27, 2010 at 10:46:50PM -0400, Aristeu Sergio Rozanski Filho wrote:
> > > > Hi Don,
> > > > > +/* deprecated */
> > > > > +static int __init nosoftlockup_setup(char *str)
> > > > > +{
> > > > > +	no_watchdog = 1;
> > > > > +	return 1;
> > > > > +}
> > > > > +__setup("nosoftlockup", nosoftlockup_setup);
> > > > > +static int __init nonmi_watchdog_setup(char *str)
> > > > > +{
> > > > > +	no_watchdog = 1;
> > > > > +	return 1;
> > > > > +}
> > > > > +__setup("nonmi_watchdog", nonmi_watchdog_setup);
> > > > didn't you just add nonmi_watchdog parameter? I don't think there's a reason
> > > > to keep compatibility here.
> > > 
> > > Hmm, I think you are right.  I thought I added that because it existed in
> > > the old nmi_watchdog setup but I can't find it.  So yeah, I can drop that.
> > you could provide a nmi_watchdog=0 backwards compatibility and warn about
> > values != 0
> > 
> > -- 
> > Aristeu
> > 
> 
> Sorry for a long delay, I think we might need to inform a user that "lapic",
> "ioapic" is no longer used (perf-nmi is supposed to substitute the former nmi
> code in a long term right?) so that for some time period, say the whole release
> cycle, if lapic or ioapic, or numbers are passed to nmi_watchdog= setup option
> we would just print out that the parameters are deprecated and better to not
> use them any longer. Hm?

Agreed.

Cheers,
Don
