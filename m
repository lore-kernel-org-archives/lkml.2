Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab1CWKx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:53:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50455 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755882Ab1CWKxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:53:24 -0400
Date: Wed, 23 Mar 2011 10:53:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        andy.green@linaro.org, Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        roger.quadros@nokia.com, greg@kroah.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110323105335.GB778@opensource.wolfsonmicro.com>
References: <4D79F068.2080009@linaro.org>
 <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>
 <1300828125.2402.300.camel@pasglop>
 <4D8924B6.8040403@linaro.org>
 <1300842219.2402.309.camel@pasglop>
 <alpine.LFD.2.00.1103222138320.11889@xanadu.home>
 <1300850595.2402.320.camel@pasglop>
 <alpine.LFD.2.00.1103222336030.11889@xanadu.home>
 <20110323093847.55e9dbba@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323093847.55e9dbba@lxorguk.ukuu.org.uk>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 09:38:47AM +0000, Alan Cox wrote:

> > Generally speaking, this wouldn't make sense.  but this is a case where 
> > a generically probed device happens to be used in a very specific 
> > hardware design with its own quirks.  in that very particular case then 
> > it certainly makes some sense.

> If it's a very specific hardware design it can do its own very specific
> internal private kernel patch, or little config app in user space. There
> isn't a valid reason to inflict that complexity on the other 99.999999%
> of users.

Just to be clear this sort of stuff is not, in general, a particularly
obscure problem for embedded systems.  General good practice in hardware
design is to remove components to achieve cost savings and improvements
in manufacturability and things like configuration SEPROMs tend to be
among the first things to go.  Vendors producing reference boards for
these markets will tend go for the cost downs on such devices even if
the volumes are relatively low to ensure that their reference designs
are directly usable in end projects, and reference designs tend to be
disproportionately visible to people working with the kernel.

In the specific case of MACs and device names for network adaptors we
have userspace solutions which are obscuring the discussion but there
are other things which get configured this way which one would usually
expect to be handled in kernel.
