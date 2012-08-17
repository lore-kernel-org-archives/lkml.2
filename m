Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab2HQBrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 21:47:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35443 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab2HQBq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 21:46:58 -0400
Date: Thu, 16 Aug 2012 18:46:31 -0700
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
Message-ID: <20120817014609.GB2949@dhcp-172-17-9-228.mtv.corp.google.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502CF9E3.2010608@linutronix.de>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 03:47:15PM +0200, Sebastian Andrzej Siewior wrote:
> On 08/16/2012 03:17 PM, Andrzej Pietrasiewicz wrote:
> >A lun is "opened" on storing the "file" attribute of the lun, it is in
> >fsg_lun_store_file, storage_common.c. So, again, this is a configfs
> >callback.
> >
> >On storing the connect attribute, the following happens: a composite driver
> >is probed, then all the configurations are iterated over, their functions
> >being bound in turn. After the gadget is set up this way, the host notices
> >connecting a new mass storage device.
> 
> The configuration has to remain unchanged until the "connect" attribute
> is changed (i.e. unconnected). That means the gadget can only be
> reconfigured once it is not active.

	Yes, that's my understanding of the driver code.  What I'm
trying to understand is the trigger for setting connect=1.  See, all of
the other configfs steps you outlined make sense to me as "part of the
gadget's internal state".  While I don't know what C1 and F1 are (I
assume G1 is Gadget1), I don't know that it matters.
	What changes the state to "active"?  That is, what triggers
setting connect=1?  Is it just part of the flow of power-up, or is there
some separation between "setting myself up" and "seeing that a host
wants to talk to me"?

Joel

-- 

"The trouble with being punctual is that nobody's there to
 appreciate it."
	- Franklin P. Jones

			http://www.jlbec.org/
			jlbec@evilplan.org
