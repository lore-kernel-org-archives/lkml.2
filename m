Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab0IXHnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 03:43:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35490 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab0IXHnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 03:43:19 -0400
Date: Fri, 24 Sep 2010 08:42:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Simon Richter <Simon.Richter@hogyros.de>
Cc: Darius Augulis <augulis.darius@gmail.com>, kgene.kim@samsung.com,
        Ben Dooks <ben-linux@fluff.org>, paulius.zaleckas@gmail.com,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH] serial: samsung: fix device name
Message-ID: <20100924074247.GB11371@n2100.arm.linux.org.uk>
References: <20100923190212.18863.25678.stgit@darius-desktop> <4C9BE577.4050504@fluff.org> <AANLkTi=S8v19iT1DC=6Nh9BEgRvKzyzKTKoJmS0Bw1Fb@mail.gmail.com> <20100924073453.GA3840@richter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924073453.GA3840@richter>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 09:34:53AM +0200, Simon Richter wrote:
> Hi,
> 
> On Fri, Sep 24, 2010 at 09:57:19AM +0300, Darius Augulis wrote:
> 
> > It does - now devices are named /dev/s3c2410_serial, and patch changes
> > its name to /dev/ttySAC
> 
> I wonder if it'd make sense to name them ttyS[0-9]. I've never
> understood why the platform standard fixed serial ports on any device
> should have a different name.

It's called namespace.  If platform serial ports are different, then
they have to have a separate namespace otherwise things like
console= end up having to have a separate namespace from the one
which the user sees in the filesystem.

Moreover, you introduce a bunch of special cases into the 8250 serial
driver - or you simply exclude the 8250 serial driver being used on a
platform.
