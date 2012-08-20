Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab2HTLTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:19:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39734 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab2HTLTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:19:43 -0400
Date: Mon, 20 Aug 2012 04:19:38 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
Subject: Re: [RFC 0/2] USB gadget - configfs
Message-ID: <20120820111938.GH2102@dhcp-172-17-9-228.mtv.corp.google.com>
Mail-Followup-To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Felipe Balbi' <balbi@ti.com>,
	'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	'Alan Stern' <stern@rowland.harvard.edu>
References: <000501cd5e79$a770be50$f6523af0$%p@samsung.com>
 <20120815081331.GL31083@dhcp-172-17-9-228.mtv.corp.google.com>
 <000101cd7bb1$73f36050$5bda20f0$%p@samsung.com>
 <502CF9E3.2010608@linutronix.de>
 <20120817014609.GB2949@dhcp-172-17-9-228.mtv.corp.google.com>
 <502E0D3B.10006@linutronix.de>
 <000201cd7c63$60186370$20492a50$%p@samsung.com>
 <502E1E23.60201@linutronix.de>
 <20120820055958.GD2102@dhcp-172-17-9-228.mtv.corp.google.com>
 <503218EF.7080906@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503218EF.7080906@linutronix.de>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 01:01:03PM +0200, Sebastian Andrzej Siewior wrote:
> On 08/20/2012 07:59 AM, Joel Becker wrote:
> >	I think what you want here is a symlink.  Create a directory
> >high in the tree called 'ready' or 'available', and when you want to
> >lock the device in place, symlink it into that directory.  This will pin
> >the item.  You can also make use of the ->allow_link() and ->drop_link()
> >callbacks to prevent symlinking an item until it is fully configured,
> >and prevent unlinking an item that is in use.
> >
> >   $ ln -s /cfg/usb-function-gadget/G1/C1/F1/f_mass_storage/lun0 \
> >         /cfg/usb-function-gadget/ready/
> >
> >or something like that.
> 
> That would be something like
> 
>   $ ln -s /cfg/usb-function-gadget/G1 \
>         /cfg/usb-function-gadget/udcs/udc1/
> 
> Where we "bind" the complete gadget (G1) including the mass storage
> configuration to the UDC (udc1 in this example).
> 
> At this point we could snapshot the complete configuration so we have
> it persistent and if somebody changes attributes within /cfg/usb-
> function-gadget/G1 it doesn't matter because we have the copy.
> 
> Is it _this_ what you want us to do? A snapshot?

	No, I don't see why you would snapshot.  You can, btw, reject
->store_attribute() operations once you are in a "ready" state.  That's
different from preventing the removal of items.

Joel


-- 

The Graham Corollary:

	The longer a socially-moderated news website exists, the
	probability of an old Paul Graham link appearing at the top
	approaches certainty.

			http://www.jlbec.org/
			jlbec@evilplan.org
