Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab1DCPWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 11:22:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34199 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1DCPWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 11:22:51 -0400
Date: Sun, 3 Apr 2011 16:22:44 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jamie Iles <jamie@jamieiles.com>, Anton Vorontsov <cbouatmailru@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH] gpio: support for Synopsys DesignWare APB GPIO
Message-ID: <20110403152244.GC5670@pulham.picochip.com>
References: <1301665638-29841-1-git-send-email-jamie@jamieiles.com>
 <alpine.LFD.2.00.1104022300130.5929@localhost6.localdomain6>
 <20110403025907.GA5670@pulham.picochip.com>
 <BANLkTimCG5t0k0XS=ojj_AqKM-7e=GB6-A@mail.gmail.com>
 <alpine.LFD.2.00.1104031118580.5929@localhost6.localdomain6>
 <20110403120344.GA1540@oksana.dev.rtsoft.ru>
 <20110403140750.GB5670@pulham.picochip.com>
 <BANLkTikoODn75U=DKiqT9xV6kVsjr5T2fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikoODn75U=DKiqT9xV6kVsjr5T2fA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Sun, Apr 03, 2011 at 08:47:25AM -0600, Grant Likely wrote:
> On Sun, Apr 3, 2011 at 8:07 AM, Jamie Iles <jamie@jamieiles.com> wrote:
> > My first idea would be to have something like:
> >
> > struct mmio_gpio_bank {
> >        unsigned int            ngpio;
> >        unsigned long           set_offs;
> >        unsigned long           clr_offs;
> >        unsigned long           dout_offs;
> >        unsigned long           din_offs;
> >        unsigned long           dir_offs;
> > };
> >
> > struct mmio_gpio_pdata {
> >        size_t                  bus_width_bits;
> >        int                     gpio_base;
> >        unsigned int            nr_banks;
> >        struct mmio_gpio_bank   banks[];
> > };
> 
> As discussed earlier in the thread, you probably don't need to support
> multiple banks with this driver.  Instead, create a separate device
> instance for each bank.

The reason I proposed this was for controllers where the registers 
aren't grouped together for each bank.  For example, the Synopsys block 
has:

	0x00-0x08 bank A control registers
	0x0c-0x14 bank B control registers
	...
	0x50	  bank A input register
	0x54	  bank B input register.

So when you mentioned before using a single register resource with 
offsets I understood it to be something like what I've proposed 
otherwise multiple banks would have overlapping resources (or the 
resource would just be used to indicate the start address rather than 
start + end).

Also, it's not clear here but this would create one gpio_chip per bank.

Jamie
