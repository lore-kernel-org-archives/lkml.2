Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab2H2TxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 15:53:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:56830 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab2H2Tw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 15:52:59 -0400
Message-ID: <503E7317.8070306@linutronix.de>
Date: Wed, 29 Aug 2012 21:52:55 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
Subject: Re: [RFC 0/2] USB gadget - configfs
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com> <20120702090907.GC13247@dhcp-172-17-9-228.mtv.corp.google.com> <000501cd5e79$a770be50$f6523af0$%p@samsung.com> <20120815081331.GL31083@dhcp-172-17-9-228.mtv.corp.google.com> <000101cd7bb1$73f36050$5bda20f0$%p@samsung.com> <502CF9E3.2010608@linutronix.de> <20120817014609.GB2949@dhcp-172-17-9-228.mtv.corp.google.com> <502E0D3B.10006@linutronix.de> <000201cd7c63$60186370$20492a50$%p@samsung.com> <502E1E23.60201@linutronix.de> <20120820055958.GD2102@dhcp-172-17-9-228.mtv.corp.google.com> <503218EF.7080906@linutronix.de> <000001cd7f75$b21d7ab0$16587010$%p@samsung.com>
In-Reply-To: <000001cd7f75$b21d7ab0$16587010$%p@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 10:19 AM, Andrzej Pietrasiewicz wrote:
> @Joel:
> However, I am wondering if it would make sense to get rid of the "connect"
> (or "ready", if you will) attribute altogether and instead use symlinks:
> when a user wants to make the gadget ready, they do an ln -s, when they want
> to unbind the gadget they remove the link. What do you think?

I started the "ready" attribue and this symlink sounds reasonable.

> There is one more thing to it, I believe; it is how to associate udc's
> with gadgets. Perhaps the most convenient way is not needing to do it
> explicitly at all: either some udc is found and the gadget is bound to it,

I would prefer explicit binding. Right now first one wins which not
good.

> or not. However, I am wondering if something in the spirit of "1984" can
> happen: all udcs are equal but some udcs are more equal than others?
> So sometimes the user might be interested in binding their gadget to
> a particular udc, or at least to a particular kind of udc (no matter
> which one if there are more than one of its kind).

Do you have a use case for this? I have a simple one: A phone with two
plugs. You select on the gui storage and network on plug #1 and serial
on plug #2. If you want to obey the selection you have to always know
which UDC ends up on plug #1 and which on #2.
That means the user _always_ wants to bind it to a particular UDC.

> And the question
> is, whether we want only explicit association with udc, only implicit
> association with udc, or both?

/usb-gadget/gadgets/g1
/usb-gadget/udcs/udc1
/usb-gadget/udcs/udc2

and now symlink g1 into udc1 and or udc2

g1 is created by the user and can be named however he wants it to be.
udc1 can be the device name which is unique as well and always the same
thing. It can have a property which distinguish it from udc2 like
memory address or something.

>
> Andrzej

Sebastian
