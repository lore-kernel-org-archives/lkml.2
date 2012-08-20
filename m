Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab2HTGAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 02:00:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42035 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab2HTGAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 02:00:09 -0400
Date: Sun, 19 Aug 2012 22:59:58 -0700
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
Message-ID: <20120820055958.GD2102@dhcp-172-17-9-228.mtv.corp.google.com>
Mail-Followup-To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Felipe Balbi' <balbi@ti.com>,
	'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	'Alan Stern' <stern@rowland.harvard.edu>
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
 <20120702090907.GC13247@dhcp-172-17-9-228.mtv.corp.google.com>
 <000501cd5e79$a770be50$f6523af0$%p@samsung.com>
 <20120815081331.GL31083@dhcp-172-17-9-228.mtv.corp.google.com>
 <000101cd7bb1$73f36050$5bda20f0$%p@samsung.com>
 <502CF9E3.2010608@linutronix.de>
 <20120817014609.GB2949@dhcp-172-17-9-228.mtv.corp.google.com>
 <502E0D3B.10006@linutronix.de>
 <000201cd7c63$60186370$20492a50$%p@samsung.com>
 <502E1E23.60201@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502E1E23.60201@linutronix.de>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 12:34:11PM +0200, Sebastian Andrzej Siewior wrote:
> On 08/17/2012 12:30 PM, Andrzej Pietrasiewicz wrote:
> >>There is a separation between "setting myself up" and "seeing that a host
> >>wants to talk to me". You are a woman. And if you not done yet done you
> >ignore
> >>the host until you are ready. Can also be ready before the host wants to
> >talk
> >>to you. It depends on your mood / use case (give the use the choice
> >between
> >>storage&  network and offer always both because we are self powered).
> >>
> >
> >You never know when she is ready... ;)
> >
> >Please note, that in the example implementation it is userspace
> >who needs to explicitly store "1" into the "connect" attribute;
> >if it is not set, connecting the cable will have no effect and,
> >conversely, if the cable is connected but the "1" is not stored,
> >the gadget will not be seen by the host.
> 
> maybe we should rename "connect" here to "ready" or "available". It
> seems to cause confusion.

	I think what you want here is a symlink.  Create a directory
high in the tree called 'ready' or 'available', and when you want to
lock the device in place, symlink it into that directory.  This will pin
the item.  You can also make use of the ->allow_link() and ->drop_link()
callbacks to prevent symlinking an item until it is fully configured,
and prevent unlinking an item that is in use.

  $ ln -s /cfg/usb-function-gadget/G1/C1/F1/f_mass_storage/lun0 \
        /cfg/usb-function-gadget/ready/

or something like that.

Joel

-- 

"Born under a bad sign.
 I been down since I began to crawl.
 If it wasn't for bad luck,
 I wouldn't have no luck at all."

			http://www.jlbec.org/
			jlbec@evilplan.org
