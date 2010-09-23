Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab0IWKwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 06:52:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44308 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750713Ab0IWKwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 06:52:11 -0400
Date: Thu, 23 Sep 2010 11:52:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100923105208.GD25663@rakim.wolfsonmicro.main>
References: <20100920150431.GD31167@sirena.org.uk>
 <20100920152726.68ac2d84@linux.intel.com>
 <20100920152705.GJ3414@rakim.wolfsonmicro.main>
 <AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
 <20100922231514.5e9967c7@linux.intel.com>
 <20100923060703.GB11198@angua.secretlab.ca>
 <20100923095411.GA25663@rakim.wolfsonmicro.main>
 <20100923112703.543b0b86@lxorguk.ukuu.org.uk>
 <20100923102708.GC25663@rakim.wolfsonmicro.main>
 <20100923115818.0cac8d06@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923115818.0cac8d06@lxorguk.ukuu.org.uk>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 11:58:18AM +0100, Alan Cox wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > So what is the plan for coping with OEM systems?  Right now the code
> > makes no provision at all that I can see for system-specific handling
> > of the SFI data which seems very optimistic.

> There are various system specific drivers which have their own sfi entry
> and name. Telling platforms apart is a problem with SFI but the latest
> firmware also supports DMI so we can get platform identification via the
> normal PC interfaces.

So the expectation is that the platform data parser functions in the SFI
device list will be querying the DMI data and selecting the actual
parsing based on that?  Perhaps adding DMI keys to the match tables so
the infrastructure is there for doing the device specific things would
cover it; minor differences could be worked out in the default match
function and we can drop back to board specific functions when it gets
too messy.

My main issue here is that the code is working on the assumption that we
have one standard idea of what the SFI data means and provides no
guidance to users about handling the inevitable variations.
