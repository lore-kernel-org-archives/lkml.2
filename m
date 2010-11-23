Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab0KWVKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 16:10:51 -0500
Received: from gate.crashing.org ([63.228.1.57]:55902 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab0KWVKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 16:10:51 -0500
Subject: Re: [PATCH v1] ppc44x:PHY fixup for USB on canyonlands board
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stefan Roese <sr@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org, linuxppc-dev@ozlabs.org,
        Rupjyoti Sarmah <rsarmah@amcc.com>, rsarmah@apm.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <201011231421.02377.sr@denx.de>
References: <201011231256.oANCur3N016433@amcc.com>
	 <201011231421.02377.sr@denx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 08:10:21 +1100
Message-ID: <1290546621.32570.85.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +	setbits8(&bcsr[7], BCSR_USB_EN);
> > +	udelay(100000);
> > +
> > +	clrbits8(&bcsr[7], BCSR_USB_EN);
> > +	udelay(100000);
> 
> Thats a total bootup delay of 200ms. Is this really needed?

In addition, so large delays should use msleep() if possible (depends
how early we are here).

Cheers,
Ben,

> And I suggest to add a few comments to the code explaining why exactly you are 
> setting/clearing the bits in the BCSR and the GPIO registers.

Seconded,

Cheers,
Ben.


