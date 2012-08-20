Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2HTLBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:01:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:33698 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab2HTLBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:01:07 -0400
Message-ID: <503218EF.7080906@linutronix.de>
Date: Mon, 20 Aug 2012 13:01:03 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
Subject: Re: [RFC 0/2] USB gadget - configfs
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com> <20120702090907.GC13247@dhcp-172-17-9-228.mtv.corp.google.com> <000501cd5e79$a770be50$f6523af0$%p@samsung.com> <20120815081331.GL31083@dhcp-172-17-9-228.mtv.corp.google.com> <000101cd7bb1$73f36050$5bda20f0$%p@samsung.com> <502CF9E3.2010608@linutronix.de> <20120817014609.GB2949@dhcp-172-17-9-228.mtv.corp.google.com> <502E0D3B.10006@linutronix.de> <000201cd7c63$60186370$20492a50$%p@samsung.com> <502E1E23.60201@linutronix.de> <20120820055958.GD2102@dhcp-172-17-9-228.mtv.corp.google.com>
In-Reply-To: <20120820055958.GD2102@dhcp-172-17-9-228.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 07:59 AM, Joel Becker wrote:
> 	I think what you want here is a symlink.  Create a directory
> high in the tree called 'ready' or 'available', and when you want to
> lock the device in place, symlink it into that directory.  This will pin
> the item.  You can also make use of the ->allow_link() and ->drop_link()
> callbacks to prevent symlinking an item until it is fully configured,
> and prevent unlinking an item that is in use.
>
>    $ ln -s /cfg/usb-function-gadget/G1/C1/F1/f_mass_storage/lun0 \
>          /cfg/usb-function-gadget/ready/
>
> or something like that.

That would be something like

   $ ln -s /cfg/usb-function-gadget/G1 \
         /cfg/usb-function-gadget/udcs/udc1/

Where we "bind" the complete gadget (G1) including the mass storage
configuration to the UDC (udc1 in this example).

At this point we could snapshot the complete configuration so we have
it persistent and if somebody changes attributes within /cfg/usb-
function-gadget/G1 it doesn't matter because we have the copy.

Is it _this_ what you want us to do? A snapshot?

>
> Joel


Sebastian
