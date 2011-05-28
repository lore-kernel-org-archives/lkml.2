Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1E1Xqi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 19:46:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45236 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab1E1Xqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 19:46:36 -0400
Date: Sun, 29 May 2011 00:46:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Rientjes <rientjes@google.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>, Samuel Ortiz <samuel@sortiz.org>
Subject: Re: IrDA driver fails on PXA255
Message-ID: <20110528234614.GV24876@n2100.arm.linux.org.uk>
References: <20110528205701.GA1788@doriath.ww600.siemens.net> <alpine.DEB.2.00.1105281628480.9934@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105281628480.9934@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 04:34:07PM -0700, David Rientjes wrote:
> The driver is attempting to allocate DMA memory and you have 
> CONFIG_ZONE_DMA disabled, which is the only reason you would get this 
> warning.  If the allocation did not fail as a result of a197b59ae6e8, the 
> page allocator may return any memory in a higher zone that the driver may 
> not be expecting.  If you had never noticed a problem before, it may be 
> possible that the driver doesn't actually have any zone restrictions and 
> GFP_DMA can be removed, but this code is pretty old.  Otherwise, it'll 
> need to depend on ZONE_DMA in the Kconfig.
> 
> Let's cc Nicolas and Russell as well.

Ouch.  We're probably going to have a pile of work to do to check that
the DMA masks on all our devices are correct for the unrestricted case
then.  That's probably going to be a very _big_ patch.
