Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab0HSM3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 08:29:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53381 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab0HSM3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 08:29:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
Date: Thu, 19 Aug 2010 14:29:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: john stultz <johnstul@us.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        Rodolfo Giometti <giometti@linux.it>, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>
References: <cover.1281956490.git.richard.cochran@omicron.at> <201008181702.03384.arnd@arndb.de> <20100819092246.GA8484@riccoc20.at.omicron.at>
In-Reply-To: <20100819092246.GA8484@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008191429.50008.arnd@arndb.de>
X-Provags-ID: V02:K0:miYg1B/xed00ytcUgiCp+GJNunIZwp4x8V7GEaGA2qU
 spprKbh9EvjESlZgDZ11OEJuCig9OiuToJDnSzzILWq1+RAAHh
 NAO/VHHKttMMZR88hOt7SYRfjUCl0gMfZ7ZbQNZlILCzb2HZpb
 1oR0dMGHWGLdsDgjOA04xWpImMLKkcR/Tu+AvIq0mQRBjwSO4v
 77cNafOahr1wnOs//N75w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 August 2010, Richard Cochran wrote:
> 
> On Wed, Aug 18, 2010 at 05:02:03PM +0200, Arnd Bergmann wrote:
> > You might want to use callbacks for these system calls that you
> > can register to at module load time, like it is done for the
> > existing syscalls.
> 
> Can you point me to a specific example?

The struct k_clock contains callback functions to clock source
specific implementations of the syscalls and other functions.
Adding a new clock source that is (potentially) implemented
as a module means you have to define a new k_clock in that module
that you register using register_posix_clock.

If you need additional syscalls to be implemented by the same
module, you can put more callback functions into struct k_clock
that would then only be implemented by the new module.

> > The simpler way (e.g. for testing) is using Kconfig dependencies, like
> > 
> > config PTP
> >       bool "IEEE 1588 Precision Time Protocol"
> > 
> > config PPS
> >       tristate "Pulse per Second"
> >       depends on PTP || !PTP
> > 
> > The depends statement is a way of expressing that when PTP is enabled,
> > PPS cannot be a module, while it may be a module if PTP is disabled.
> 
> THis did not work for me.
> 
> What I got was, in effect, two independent booleans.

Hmm, right. I wonder what I was thinking of then.

You can certainly do

config PTP
	bool "IEEE 1588 Precision Time Protocol"
	depends on PPS != m

but that will hide the PTP option if PPS is set to 'm', which is normally
not what you want.

	Arnd
