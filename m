Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab2HTLSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:18:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39724 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab2HTLSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:18:05 -0400
Date: Mon, 20 Aug 2012 04:17:57 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
Subject: Re: [RFC 0/2] USB gadget - configfs
Message-ID: <20120820111756.GG2102@dhcp-172-17-9-228.mtv.corp.google.com>
Mail-Followup-To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	'Sebastian Andrzej Siewior' <bigeasy@linutronix.de>,
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
 <000001cd7eb1$4d189420$e749bc60$%p@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cd7eb1$4d189420$e749bc60$%p@samsung.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 10:53:42AM +0200, Andrzej Pietrasiewicz wrote:
> Hello Joel,
> 
> Thanks for your reply.
> 
> On Monday, August 20, 2012 8:00 AM Joel Becker wrote:
> > 
> > 	I think what you want here is a symlink.  Create a directory
> > high in the tree called 'ready' or 'available', and when you want to
> > lock the device in place, symlink it into that directory.  This will pin
> > the item.  You can also make use of the ->allow_link() and ->drop_link()
> > callbacks to prevent symlinking an item until it is fully configured,
> > and prevent unlinking an item that is in use.
> > 
> >   $ ln -s /cfg/usb-function-gadget/G1/C1/F1/f_mass_storage/lun0 \
> >         /cfg/usb-function-gadget/ready/
> > 
> 
> Is using the userspace program "ln" the way you suggest doing it? Or just
> a suggestion about what should be the link target and the link name?

You could use ln, you could use symlink(2), or some other method.  The
symlink itself is the goal.  The names are my best guess at how your
system is laid out; it's not meant to pick a name for you.

> If links are to be created from userspace then some other process can race
> us and rmdir "lun0" before ln is called, can't it?

Yes, but that same process can race the write of '1' to "connect" as well,
right?  I don't see the difference.

> And a question to you as the creator of configfs: is using symlinks to
> prevent config item deletion their intended purpose? How do you like it?

	Yes, it is an intended use.  Another intended use is
simplification of access.  For example, if you have all connected things
in the "ready" subdirectory, you don't have to go scanning all the
"connect" files to find them.

Joel

-- 

"I always thought the hardest questions were those I could not answer.
 Now I know they are the ones I can never ask."
			- Charlie Watkins

			http://www.jlbec.org/
			jlbec@evilplan.org
