Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab0EQUUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:20:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46335 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752629Ab0EQUUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:20:45 -0400
Subject: Re: Fwd: [linux-pm] Power Domain Framework
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar <sunder.svit@gmail.com>
Cc: Deepak Sikri <deepak.sikri79@gmail.com>, viresh.kumar@st.com,
       rajeev-dlh.kumar@st.com, armando.visconti@st.com,
       linux-kernel@vger.kernel.org, vipin.kumar@st.com, shiraz.hashim@st.com,
       linux-pm@lists.linux-foundation.org, linus.walleij@stericsson.com,
       STEricsson_nomadik_linux@list.st.com
In-Reply-To: <AANLkTiniwUDg8rQzwgm_X7EbkQJ9tHzBfVtaJRiNE9az@mail.gmail.com> (sfid-20100517_172310_177677_DDC70D3F)
References: <AANLkTinZU1D1rMOBQDi47tRhXrOXwduQIdni7bCXdce0@mail.gmail.com>
	 <20100510140527.GG5199@sirena.org.uk>
	 <AANLkTikyqnKDNz7FIUvLDAvBReHskHvRCrEz2qBBqseH@mail.gmail.com>
	 <20100517031613.GA3130@opensource.wolfsonmicro.com>
	 <AANLkTimDdBCnRFMDiUkuNKanOzuPNwCpfRv9Gsi03Lsy@mail.gmail.com>
	 <AANLkTinZRhUpFTOOUCdH5dEl3QaXn10USL_hPPQX8cie@mail.gmail.com>
	 <20100517143319.GC5257@opensource.wolfsonmicro.com>
	 <AANLkTiniwUDg8rQzwgm_X7EbkQJ9tHzBfVtaJRiNE9az@mail.gmail.com>
	 (sfid-20100517_172310_177677_DDC70D3F)
Content-Type: text/plain; charset="UTF-8"
Organization: Wolfson Microelectronics
Date: Mon, 17 May 2010 13:20:50 -0700
Message-ID: <1274127650.2698.159.camel@finisterre.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 21:53 +0530, Sundar wrote:
> On Mon, May 17, 2010 at 8:03 PM, Mark Brown
> > On Mon, May 17, 2010 at 07:03:57PM +0530, Sundar wrote:

> > The major goal of the regulator API is to allow us to match up consumer
> > drivers with regulator drivers without having any device specific tie
> > between the two.  Pushing things that need such tie in through the API
> > breaks that.

> Aren't machine constraints, setting maximum current limit based on total loads
> similar to primitive tie ups between devices and regulator driver?

Like I say, there are similarities - it's the way the parts of the
system are connected and the level of knowledge they can have of each
other that differs.

> I am still confused about the knowledge of regulator about its consumer. How
> I see is, with the added controls, it is still devoid of any
> information about its
> clients. All that a regulator still would know is if at all there are
> any clients which

As I said in reply to the patch I am concerned that this may be an
oversimplification relative to what general hardware needs.

> require it at full load. I think the function *set_optimal_load is
> very similar to a OPP
> control mechanism. Instead of summing up load currents, now there are
> constraints.
> Probably you may look at the patch set at the end of this mail and comment.

Right, and if we could work out some generic constraints that meshed
well with the regulator API constraints it might be sensible to do this
(though it may still be more sensible to just clone the bits shared with
regulator API if there's not enough overlap in anything except really
basic stuff like enables).

> > includes a strong tie in with information about the device clocking.
> > Typically changing the operating mode will change or limit the clock
> > rates in use in various parts of the device.

> cannot these be handled with existing/new notifiers in place?

Things may start to get complicated there when the clocking and
operating points get tightly enough interlinked, and I would worry that
you'd end up spending more time faffing about with back and forth
callbacks than would be required to just implement something specific to
operating modes.

