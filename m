Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab0DPQOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 12:14:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758511Ab0DPQOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 12:14:17 -0400
Date: Fri, 16 Apr 2010 12:14:01 -0400
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100416161401.GI15159@redhat.com>
References: <1271366710-17468-1-git-send-email-dzickus@redhat.com>
 <20100416014712.GC15570@nowhere>
 <20100416141213.GC15159@redhat.com>
 <20100416144302.GB5162@nowhere>
 <20100416150407.GH15159@redhat.com>
 <20100416153210.GG5162@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100416153210.GG5162@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 05:32:12PM +0200, Frederic Weisbecker wrote:
> > I'll try to implement this.  Any objections if I combined hardlockup and
> > softlockup with per cpu watchdog_warn and have bit masks for HARDLOCKUP
> > and SOFTLOCKUP?  I hate to just waste per cpu space for this.
> 
> 
> 
> Hmm, a hardlockup can come in after a softlockup.

Let me re-explain what I meant.  It was meant to do double duty.  The
softlockup code only checks the SOFTLOCKUP bit and the hardlockup only
ever checks the HARDLOCKUP bit.

ie if get_cpu_var(watchdog_warn) && HARDLOCKUP { return; }

> Don't worry too much about memory: usually the more you have cpu,
> the more you have memory :)
> Plus this is debugging code, not something supposed to be enabled
> in production.

Well depends on your POV.  In RHEL we enable both NMI_WATCHDOG and
SOFTLOCKUP on production systems (and we have customers that are
thankful for that :-) ).

Cheers,
Don
