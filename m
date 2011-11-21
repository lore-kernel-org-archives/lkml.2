Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1KUOv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:51:27 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52840 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab1KUOv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:51:26 -0500
Date: Mon, 21 Nov 2011 14:51:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Rabin Vincent <rabin@rab.in>, Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Bhavna YADAV <bhavna.yadav@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: [PATCH V2 5/5] gpio/gpio-stmpe: ADD support for stmpe variant
 801
Message-ID: <20111121145116.GA32137@sirena.org.uk>
References: <cover.1321507421.git.viresh.kumar@st.com>
 <d2b66ba1a6c2b34f7e0b82e31bc360684c734759.1321507421.git.viresh.kumar@st.com>
 <CAH+eYFCLauXusdDs75qm2rGB5Y0==bhTbxPJD+gyaaZQVbvsVw@mail.gmail.com>
 <4EC9D175.2070008@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC9D175.2070008@st.com>
X-Cookie: New crypt.  See /usr/news/crypt.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 09:50:05AM +0530, Viresh Kumar wrote:
> On 11/18/2011 5:29 PM, Rabin Vincent wrote:

> >  (1) for 801, when clearing one GPIO, sets all the others.

> I assumed stmpe_set_bits will only affect bits which are 1
> in mask and i was wrong. :(

That does look like a straight bug in stmpe_set_bits() which ought to be
fixed regardless of anything else.

> >  (2) for other devices, adds an an unnecessary read (within stmpe_set_bits()),
> >      which wasn't there before.

> Correct.

> > Please rework to something like:

Looking at the code in stmpe.c it might be as well to convert to regmap
which would if nothing else save a bunch of custom code in the driver
and let you use the cache code to eliminate the read.  Probably that
will help eliminate reads in other places too.
