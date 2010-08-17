Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab0HQNZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:25:33 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:51498 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756962Ab0HQNZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:25:30 -0400
Date: Tue, 17 Aug 2010 14:24:27 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Alan Cox <alan@linux.intel.com>
Cc: Yong Wang <yong.y.wang@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>
Subject: Re: One question about 8250 UART driver
Message-ID: <20100817132427.GA17861@linux-mips.org>
References: <20100817013734.GA28407@ywang-moblin2.bj.intel.com>
 <20100817091622.5aa3dcf2@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817091622.5aa3dcf2@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 09:16:22AM +0100, Alan Cox wrote:

> > We have a PCI based UART controller that is compatible with the
> > existing 8250 serial driver in most aspects. However, one exception
> > is that our UART controller can take advantage of the onboard DMA
> > contoller to achieve higher throughput. Could you please share your
> > insights about what is the proper way to add such DMA support into
> > existing 8250 driver?
> 
> I'd say the same as I said to the other folks who asked this - create a
> new driver. All the DMA based 8250 devices have differing DMA engines
> and it'll become unmanagable in the existing driver.
> 
> Once we can see which bits of the existing code are useful for the DMA
> 8250-style devices we can then create an 8250-lib.c which contains the
> bits that are useful to 8250 and to non standard 8250-like devices.

An existing example is drivers/serial/ioc3_serial.c.  IOC3 is an SGI
custom chip which is only being used in SGI systems.  It has a PCI
master and 486-style slave bus to which a SuperIO chip is connected.
The IOC3 can either be configured to use the chip in legacy mode; then
the standard 8250 driver will work fine.  It also support a DMA mode
with receive and transmit rings which make it similar to a network chip.

  Ralf
