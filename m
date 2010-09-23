Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab0IWOLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:11:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46969 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753600Ab0IWOLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:11:36 -0400
Date: Thu, 23 Sep 2010 15:11:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        x86@kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100923141133.GG25663@rakim.wolfsonmicro.main>
References: <20100920152705.GJ3414@rakim.wolfsonmicro.main>
 <AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
 <20100922231514.5e9967c7@linux.intel.com>
 <20100923060703.GB11198@angua.secretlab.ca>
 <20100923095411.GA25663@rakim.wolfsonmicro.main>
 <20100923112703.543b0b86@lxorguk.ukuu.org.uk>
 <20100923102708.GC25663@rakim.wolfsonmicro.main>
 <20100923115818.0cac8d06@lxorguk.ukuu.org.uk>
 <20100923105208.GD25663@rakim.wolfsonmicro.main>
 <20100923111347.0cf93bb3@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923111347.0cf93bb3@linux.intel.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 11:13:47AM +0100, Alan Cox wrote:

> > So the expectation is that the platform data parser functions in the
> > SFI device list will be querying the DMI data and selecting the actual
> > parsing based on that?  Perhaps adding DMI keys to the match tables so
> > the infrastructure is there for doing the device specific things would

> That will just encourage people not to be careful.

I'm not see anything here which provides a way for people to be careful
- people just need to add the code directly into the parser if there's
no format defined in the kernel the're working on.  If (as will be the
case with most chips) there's nothing there then people are pretty much
left to their own devices unless they choose to work upstream.  From
experience what the overwheming majority of OEMs will actually do is
work on the latest kernel from their distro of choice, normally without
contributing their changes anywhere.

> > My main issue here is that the code is working on the assumption that
> > we have one standard idea of what the SFI data means and provides no
> > guidance to users about handling the inevitable variations.

> There should be no variations and the nature of the platform means that
> might even work out. I don't really want to add it to the table unless
> we have lots needing DMI data. Right now we don't and there are
> multiple platform implementations in existence.

What is it about this platform that is going to restrict the problem?

Code which makes this sort of assumption about knowing the platforms
that the device will be deployed on well is relatively common but the
usual result is that OEMs want to change the reference platforms and the
assumptions that the code has been making about the systems and about
how people will work with the code break down.  This problem is much
more pronounced in the embedded space where the hardware is much less
self-describing and regular than on PCs.
