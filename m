Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab1E2V5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 17:57:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41873 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1E2V5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 17:57:18 -0400
Date: Sun, 29 May 2011 22:56:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Rientjes <rientjes@google.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.y.miao@gmail.com>, Samuel Ortiz <samuel@sortiz.org>
Subject: Re: IrDA driver fails on PXA255
Message-ID: <20110529215656.GA5576@n2100.arm.linux.org.uk>
References: <20110528205701.GA1788@doriath.ww600.siemens.net> <alpine.DEB.2.00.1105281628480.9934@chino.kir.corp.google.com> <BANLkTim9YdhjY75CzMsSOCVKZWi-WKZ5wA@mail.gmail.com> <alpine.DEB.2.00.1105291410450.9658@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105291410450.9658@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 02:17:02PM -0700, David Rientjes wrote:
> On Sun, 29 May 2011, Dmitry Eremin-Solenikov wrote:
> 
> > What about changing your patch for less intrusive one (to emit a
> > WARN_ON) for at least one
> > or two major releases and only then changing it back to the current state?
> > 
> 
> That would return memory that is not guaranteed to be within the first 
> 16MB of address space, so a GFP_DMA allocation would succeed with memory 
> not from ZONE_DMA.

Err, no. GFP_DMA returns memory in a zone which the platform has setup.
There's nothing specific about it being "16MB" or any other size; the
arch can chose what size that is.

> That's an invalid configuration, so users, including 
> you, should at least edit their .config by hand to enable CONFIG_ZONE_DMA 
> as a workaround.

Again, no.  This change has caused a load of previously working drivers
to suddenly start failing without _any_ explanation why or even warning
about the change.  It needs to start off as a WARN_ON() so that stuff
can be fixed, and then changed to a hard error.
