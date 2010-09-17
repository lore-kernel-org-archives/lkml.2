Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab0IQP7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:59:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33471 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753854Ab0IQP7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:59:39 -0400
Date: Fri, 17 Sep 2010 16:59:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nishanth Menon <nm@ti.com>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        linux-doc <linux-doc@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>,
        "Aguirre, Sergio" <saaguirre@ti.com>, Andi Kleen <ak@linux.intel.com>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Eduardo Valentin <eduardo.valentin@nokia.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "Gopinath, Thara" <thara@ti.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "Granados Dorado, Roberto" <x0095451@ti.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Romit Dasgupta <ro.mit@ti.com>, Tero Kristo <Tero.Kristo@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Premi, Sanjeev" <premi@ti.com>
Subject: Re: [linux-pm] [PATCH] opp: introduce library for device-specific
 OPPs
Message-ID: <20100917155937.GB29596@rakim.wolfsonmicro.main>
References: <1284686973-13993-1-git-send-email-nm@ti.com>
 <20100917153643.GC29739@sirena.org.uk>
 <4C938EE2.1010307@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C938EE2.1010307@ti.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 10:53:06AM -0500, Nishanth Menon wrote:
> Mark Brown had written, on 09/17/2010 10:36 AM, the following:

> >It might be clearer to use some term other than enabled in the code -
> >when reading I wasn't immediately sure if enabled meant that it was
> >available to be selected or if it was the active operating point.  How
> >about 'allowed' (though I'm not 100% happy with that)?

> ;).. The opp is enabled or disabled if it is populated, it is
> implicit as being available but not enabled- how about active? this
> would change the opp_enable/disable functions to opp_activate,
> opp_deactivate..

> Recommendations folks?

The enable/disable thing wasn't so noticable in the API itself, it was
in the data structures that I found it confusing - the core has a
different idea about what's going on with the system as a whole compared
to the decision that an individual device is taking.

> >When reading the description I'd expected to see some facility to
> >trigger selection of an active operating point in the library (possibly
> >as a separate call since you might have a bunch of operating points
> >being updated in quick succession) but it looks like that needs to be
> >supplied externally at the minute?

> The intent is we use the opp_search* functions to pick up the opp
> and enable/activate it and disable/deactivate it.

Sure, I get that bit.  What I meant was that I was expecting something
that would say that changes had been made to the enabled/disabled sets
and that it'd be a good idea to rescan, especially for cases where the
devices change their requirements but the OPPs need to be done over a
larger block.
