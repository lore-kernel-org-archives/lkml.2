Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab2HUOuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:50:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54512 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab2HUOuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:50:13 -0400
Date: Tue, 21 Aug 2012 15:50:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Poddar, Sourav" <sourav.poddar@ti.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [RFC/PATCH 4/4] gpio: smscece: Add support for gpio IO
 expander feature
Message-ID: <20120821145009.GE21557@sirena.org.uk>
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
 <1345545940-2232-5-git-send-email-sourav.poddar@ti.com>
 <20120821105333.GW10347@arwen.pp.htv.fi>
 <CAKdam56DiFpnoQwrHe1tjQWLMy5vP9ynstNj_n=OyMxkJJAUOA@mail.gmail.com>
 <20120821120052.GD10347@arwen.pp.htv.fi>
 <CAKdam55SqXiCGv766yxoY1GdDjxNCYNaDdNZPaeLTAXc+3+c6g@mail.gmail.com>
 <20120821122217.GF10347@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821122217.GF10347@arwen.pp.htv.fi>
X-Cookie: Those who can't write, write manuals.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 03:22:18PM +0300, Felipe Balbi wrote:
> On Tue, Aug 21, 2012 at 05:50:28PM +0530, Poddar, Sourav wrote:

> > If I am understanding correctly, if they both uses the same bit we cannot
> > use both for a particular user. ?

> we can, it's just a bit more complex. If a user request both LOW and
> HIGH, then you start with HIGH, once it triggers, before calling the
> nested IRQ handler, you need to change it LOW. When low triggers, before
> calling the nested IRQ handler, you need to change it to HIGH again. And
> so on. I'm just not sure if that's valid on linux IRQ subsystem.

The given example was for keypress - usually a system would use edge
triggered interrupts in combination with reading the GPIO state rather
than level triggered interrupts.
