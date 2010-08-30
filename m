Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab0H3S2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 14:28:08 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:58183 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537Ab0H3S2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 14:28:06 -0400
Date: Mon, 30 Aug 2010 14:49:46 -0400
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        cjb@laptop.org, Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: Re: [PATCH 9/9] x86: OLPC: add OLPC device-tree support
Message-ID: <20100830144946.5c0bce22@debxo>
In-Reply-To: <AANLkTi=EMkZLiAG7-ni8_7K=qtAriv=AfSUZ58661jNY@mail.gmail.com>
References: <20100628215407.2017bf2f@debian>
	<20100829235100.6dcedcb8@debxo>
	<20100830000751.2b845d05@debxo>
	<AANLkTi=EMkZLiAG7-ni8_7K=qtAriv=AfSUZ58661jNY@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010 12:14:57 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Sun, Aug 29, 2010 at 10:07 PM, Andres Salomon
> <dilinger@queued.net> wrote:
> >
> > Make use of PROC_DEVICETREE to export the tree, and sparc's
> > PROMTREE code to call into OLPC's Open Firmware to build the tree.
> >
> > This also adds an init hook to proc_device_tree_init so that we can
> > ensure the device tree has been built prior to the proc_root_init
> > stuff attempting to populate /proc/device-tree.
> 
> I'm not clear as to why this is needed.  I would expect OLPC platform
> setup code would take care of extracting the device tree well before
> the kernel gets to setting up the representation in /proc/device-tree.
> 
> g.
> 

For simplicity; the OLPC platform setup code runs very early during
boot.  I preferred to keep that as minimal as possible, and defer
device tree allocation until the x86 mm code has finished initializing
(this skipping all the fun bootmem/etc work that'll be happening for
x86 soon).

Of course, once it's done initializing, one can either hardcode an
olpc_init_devtree call at the end of x86's setup_arch, or we can add a
generic hook for late devtree initialization right before proc
populates /proc/device-tree.  I chose the latter, but it could easily
be changed to the former if folks feel strongly about it.

I would've normally just used an initcall for it, but the proc_devtree
code runs prior to any of the initcall hooks.
