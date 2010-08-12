Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778Ab0HLTIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:08:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab0HLTI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:08:29 -0400
Date: Thu, 12 Aug 2010 11:46:53 -0700
From: Greg KH <gregkh@suse.de>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Samium Gromoff <_deepfire@feelingofgreen.ru>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 56/68] serial: MMIO32 support for 8250_early.c
Message-ID: <20100812184653.GA29197@suse.de>
References: <20100810214425.GB17385@kroah.com>
 <1281477570-18944-56-git-send-email-gregkh@suse.de>
 <AANLkTinc6px4BD7CnuvaBE5kWgZGc9cN45QebjfcbgVb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinc6px4BD7CnuvaBE5kWgZGc9cN45QebjfcbgVb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 11:43:15AM -0700, Tony Luck wrote:
> On Tue, Aug 10, 2010 at 2:59 PM, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> > +       if (mmio || mmio32)
> > +               printk(KERN_INFO
> > +                      "Early serial console at MMIO%s 0x%llu (options '%s')\n",
> > +                       mmio32 ? "32" : "",
> > +                       (unsigned long long)port->mapbase,
> > +                       device->options);
> > +       else
> > +               printk(KERN_INFO
> > +                     "Early serial console at I/O port 0x%lu (options '%s')\n",
> > +                       port->iobase,
> > +                       device->options);
> > +
> 
> This change looks to be responsible for some confusing dmesg output. Here's some
> diff between v2.6.35 and current Linus tree:
> 
> 
> < Early serial console at I/O port 0x3f8 (options '115200')
> ---
> > Early serial console at I/O port 0x1016 (options '115200')
> 
> Note that my serial port didn't move to a different address. Hex(3f8)
> == Decimal(1016)
> 
> I think those two printk formats should be using 'x' format rather than 'u' :-)

Very good point, someone want to send me a patch?

thanks,

greg k-h
