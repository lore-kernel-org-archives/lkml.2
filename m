Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab2HPNrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:47:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:43868 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab2HPNrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:47:19 -0400
Message-ID: <502CF9E3.2010608@linutronix.de>
Date: Thu, 16 Aug 2012 15:47:15 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
CC: "'Joel Becker'" <jlbec@evilplan.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
Subject: Re: [RFC 0/2] USB gadget - configfs
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com> <20120702090907.GC13247@dhcp-172-17-9-228.mtv.corp.google.com> <000501cd5e79$a770be50$f6523af0$%p@samsung.com> <20120815081331.GL31083@dhcp-172-17-9-228.mtv.corp.google.com> <000101cd7bb1$73f36050$5bda20f0$%p@samsung.com>
In-Reply-To: <000101cd7bb1$73f36050$5bda20f0$%p@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 03:17 PM, Andrzej Pietrasiewicz wrote:
> A lun is "opened" on storing the "file" attribute of the lun, it is in
> fsg_lun_store_file, storage_common.c. So, again, this is a configfs
> callback.
>
> On storing the connect attribute, the following happens: a composite driver
> is probed, then all the configurations are iterated over, their functions
> being bound in turn. After the gadget is set up this way, the host notices
> connecting a new mass storage device.

The configuration has to remain unchanged until the "connect" attribute
is changed (i.e. unconnected). That means the gadget can only be
reconfigured once it is not active.

> So it seems the only chance to call config_item_depend is in a configfs
> callback. Or is it?
>
> Thanks,
>
> Andrzej

Sebastian
