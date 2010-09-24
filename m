Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab0IXRz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:55:27 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35642 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab0IXRzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:55:25 -0400
Subject: Re: [PATCH 1/8] posix clocks: introduce a syscall for clock tuning.
From: john stultz <johnstul@us.ibm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100924072946.GA5043@riccoc20.at.omicron.at>
References: <cover.1285261533.git.richard.cochran@omicron.at>
	 <b94ef1cd9c04ef3ad5964408bd0af7251add78de.1285261534.git.richard.cochran@omicron.at>
	 <1285271331.2587.56.camel@localhost.localdomain>
	 <20100924072946.GA5043@riccoc20.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 10:55:14 -0700
Message-ID: <1285350914.3514.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-24 at 09:29 +0200, Richard Cochran wrote:
> On Thu, Sep 23, 2010 at 12:48:51PM -0700, john stultz wrote:
> > So I'd still split this patch up a little bit more.
> > 
> > 1) Patch that implements the ADJ_SETOFFSET  (*and its implementation*)
> > in do_adjtimex.
> > 
> > 2) Patch that adds the new syscall and clock_id multiplexing.
> > 
> > 3) Patches that wire it up to the rest of the architectures (there's
> > still a bunch missing here).
> 
> I was not sure what the policy is about adding syscalls. Is it the
> syscall author's responsibility to add it into every arch?
> 
> The last time (see a2e2725541fad7) the commit only added half of some
> archs, and ignored others. In my patch, the syscall *really* works on
> the archs that are present in the patch.
> 
> (Actually, I did not test blackfin, since I don't have one, but I
> included it since I know they have a PTP hardware clock.)

I'm not sure about policy, but I think for completeness sake you should
make sure every arch supports a new syscall. You're not expected to be
able to test every one, but getting the basic support patch sent to
maintainers should be done.

> > > +static inline int common_clock_adj(const clockid_t which_clock, struct timex *t)
> > > +{
> > > +	if (CLOCK_REALTIME == which_clock)
> > > +		return do_adjtimex(t);
> > > +	else
> > > +		return -EOPNOTSUPP;
> > > +}
> > 
> > 
> > Would it make sense to point to the do_adjtimex() in the k_clock
> > definition for CLOCK_REALTIME rather then conditionalizing it here?
> 
> But what about CLOCK_MONOTONIC_RAW, for example?

-EOPNOTSUPP

> Does it make sense to allow it to be adjusted?

No. I think only CLOCK_REALTIME would make sense of the existing clocks.

I'm just suggesting you conditionalize it from the function pointer,
rather then in the common function.

thanks
-john


