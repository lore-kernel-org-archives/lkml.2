Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab2I1In0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:43:26 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:37370 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab2I1InW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:43:22 -0400
Date: Fri, 28 Sep 2012 10:43:03 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] sta2x11-mfd : add apb-soc regs driver and factor out common code
Message-ID: <20120928084303.GB22500@mail.gnudd.com>
References: <1347445374-32140-1-git-send-email-ciminaghi@gnudd.com> <1347445374-32140-2-git-send-email-ciminaghi@gnudd.com> <20120925192048.GA17038@sirena.org.uk> <20120926145615.GJ10147@mail.gnudd.com> <20120926150429.GQ4428@opensource.wolfsonmicro.com> <20120926163145.GK10147@mail.gnudd.com> <20120926164932.GS4428@opensource.wolfsonmicro.com> <20120927134110.GD6799@mail.gnudd.com> <20120927134919.GW4428@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120927134919.GW4428@opensource.wolfsonmicro.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 02:49:19PM +0100, Mark Brown wrote:
> On Thu, Sep 27, 2012 at 03:41:10PM +0200, Davide Ciminaghi wrote:
> 
> > Maybe there's another solution: what about adding a couple of function
> > pointers (lock, unlock) to struct regmap_config ? If they're set to NULL,
> > everything works as usual. If they're not NULL, regmap uses such functions
> > to do locking and unlocking instead of the usual ones (and regmap_bus.fast_io
> > is ignored). I think this wouldn't hurt existing regmap users and allow
> > sta2x11-mfd to have just one spinlock for everything, no need for nested
> > locking this way.
> 
> That might work, yes, and would be generally useful I think.  Or we
> could add regmap based versions of the clock utilities (which would also
> be useful anyway).  Or both.

I have a (first, incomplete but working) clock framework implementation for
the sta2x11 ready, but can't submit it until these sta2x11-mfd patches have
been accepted.
And then of course many of the drivers we need on sta2x11 depend on the
clock framework (they're amba drivers). So, since sta2x11-mfd is blocking much
of our work, I would proceed like this:

1. Regmap patch for overriding lock/unlock functions
2. Regmap based reimplementation of sta2x11-mfd (using sta2x11 special
   lock/unlock functions).
3. Submission of sta2x11 common clock framework as is (using the current
   version of the clock framework helpers, no regmap).
4. Patches for some amba drivers to get them to work on sta2x11.
5. Regmap related patches for the common clock framework.

Does this sound reasonable ?

Thanks and regards
Davide






