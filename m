Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab1CCRIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:08:11 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:40876 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758464Ab1CCRIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:08:09 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1856kkLzU85mjFp8iOLlDIlQr6/JwCiDBOX5Z3PYu
	Z7lBqxT46CTcrN
Date: Thu, 3 Mar 2011 18:07:59 +0100
From: torbenh <torbenh@gmx.de>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 28/28] posix clocks: Introduce dynamic clocks
Message-ID: <20110303170759.GF4903@siel.b>
Mail-Followup-To: Richard Cochran <richardcochran@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	John Stultz <john.stultz@linaro.org>,
	Richard Cochran <richard.cochran@omicron.at>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
References: <20110201134320.688829863@linutronix.de>
 <20110201134420.164172635@linutronix.de>
 <20110303145008.GE4903@siel.b>
 <20110303160114.GA4284@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303160114.GA4284@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 05:01:14PM +0100, Richard Cochran wrote:
> On Thu, Mar 03, 2011 at 03:50:08PM +0100, torbenh wrote:
> > On Tue, Feb 01, 2011 at 01:52:35PM -0000, Thomas Gleixner wrote:
> > > +static int pc_clock_adjtime(clockid_t id, struct timex *tx)
> > > +{
> > > +	struct posix_clock_desc cd;
> > > +	int err;
> > > +
> > > +	err = get_clock_desc(id, &cd);
> > > +	if (err)
> > > +		return err;
> > 
> > there is no permission check here.
> > if i get the clock fd in READ mode, i can still adjtime.
> > same for settime.
> 
> You are right, but I think the check should be for the capability
> instead. Checking the file mode for RDWR seems a bit pedantic to me.

i dont see, why an fd based clock, which already has associated permissions,
should check against the capability.
why should the ptpd be running as root ?
changing the permissions of /dev/ptp0 to allow ptpd to set the
clock should be enough. 

> 
> For the normal system timer, clock_settime calls security_settime, but
> adjtimex calls capable(CAP_SYS_TIME) directly. Perhaps adjtimex should
> also use the security call, too.

probably yes.

> 
> Thanks,
> 
> Richard
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
torben Hohn
