Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab2HUITo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:19:44 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:48513 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2HUITl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:19:41 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
 <20120702090907.GC13247@dhcp-172-17-9-228.mtv.corp.google.com>
 <000501cd5e79$a770be50$f6523af0$%p@samsung.com>
 <20120815081331.GL31083@dhcp-172-17-9-228.mtv.corp.google.com>
 <000101cd7bb1$73f36050$5bda20f0$%p@samsung.com>
 <502CF9E3.2010608@linutronix.de>
 <20120817014609.GB2949@dhcp-172-17-9-228.mtv.corp.google.com>
 <502E0D3B.10006@linutronix.de> <000201cd7c63$60186370$20492a50$%p@samsung.com>
 <502E1E23.60201@linutronix.de>
 <20120820055958.GD2102@dhcp-172-17-9-228.mtv.corp.google.com>
 <503218EF.7080906@linutronix.de>
In-reply-to: <503218EF.7080906@linutronix.de>
Subject: RE: [RFC 0/2] USB gadget - configfs
Date: Tue, 21 Aug 2012 10:19:32 +0200
Message-id: <000001cd7f75$b21d7ab0$16587010$%p@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1+yKH+61TWsR8zSAWLyxykf705fwAqo9AA
Content-language: pl
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sebastian,

On Monday, August 20, 2012 1:01 PM Sebastian Andrzej Siewior wrote

<snip>

> 
> That would be something like
> 
>    $ ln -s /cfg/usb-function-gadget/G1 \
>          /cfg/usb-function-gadget/udcs/udc1/
> 
> Where we "bind" the complete gadget (G1) including the mass storage
> configuration to the UDC (udc1 in this example).
> 

As far as I understand it, Joel's intention was only to show how it is
possible to prohibit removing some items with rmdir; in this case
if a "lun0" is linked to from somewhere else it is not possible to
do "rmdir lun0"; this was the purpose of my original question.

@Joel:
However, I am wondering if it would make sense to get rid of the "connect"
(or "ready", if you will) attribute altogether and instead use symlinks:
when a user wants to make the gadget ready, they do an ln -s, when they want
to unbind the gadget they remove the link. What do you think?

There is one more thing to it, I believe; it is how to associate udc's
with gadgets. Perhaps the most convenient way is not needing to do it
explicitly at all: either some udc is found and the gadget is bound to it,
or not. However, I am wondering if something in the spirit of "1984" can
happen: all udcs are equal but some udcs are more equal than others?
So sometimes the user might be interested in binding their gadget to
a particular udc, or at least to a particular kind of udc (no matter
which one if there are more than one of its kind). And the question
is, whether we want only explicit association with udc, only implicit
association with udc, or both?

Andrzej



