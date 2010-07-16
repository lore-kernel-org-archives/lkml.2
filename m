Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab0GPEoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 00:44:30 -0400
Received: from mail.perches.com ([173.55.12.10]:1925 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab0GPEo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 00:44:27 -0400
Subject: Re: [PATCH 12/25] char: Convert pci_table entries to PCI_VDEVICE
 (if PCI_ANY_ID is used)
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: Peter Huewe <PeterHuewe@gmx.de>,
        Kernel Janitors <kernel-janitors@vger.kernel.org>,
        "Digi International, Inc" <Eng.Linux@digi.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <20100716042943.GB28607@suse.de>
References: <201007152052.38060.PeterHuewe@gmx.de>
	 <20100715204540.GB24463@suse.de> <1279227615.5816.96.camel@Joe-Laptop.home>
	 <20100716042943.GB28607@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Jul 2010 21:44:23 -0700
Message-ID: <1279255463.4526.19.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-15 at 21:29 -0700, Greg KH wrote:
> On Thu, Jul 15, 2010 at 02:00:15PM -0700, Joe Perches wrote:
> > On Thu, 2010-07-15 at 13:45 -0700, Greg KH wrote:
> > > I much prefer the PCI_DEVICE() macro instead, and as such, I'm not
> > > willing to take any of these patches, sorry.
> > grepping for pci device ids using constants and
> > expecting the result to be comprehensive isn't
> > sensible.
> But it's a nice goal :)

I think your goal is not a good one.

For instance:

$ grep -rP --include=*.[ch] "\bPCI_VDEVICE\s*\(\s*INTEL" drivers | wc -l
201
$ grep -rP --include=*.[ch] "\bPCI_DEVICE\s*\(PCI_VENDOR_ID_INTEL" drivers | wc -l
45
$ grep -rP --include=*.[ch] "\bPCI_DEVICE\s*\(\s*0x8086" drivers | wc -l
38

I'd much rather do a search for "PCI_VDEVICE.*INTEL"



