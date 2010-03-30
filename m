Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab0C3S3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:29:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37683 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755443Ab0C3S3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:29:34 -0400
Date: Tue, 30 Mar 2010 19:33:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: pavan_savoy@ti.com
Cc: marcel@holtmann.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging: sources for HCI LL PM protocol
Message-ID: <20100330193329.40564ab9@lxorguk.ukuu.org.uk>
In-Reply-To: <792863.15718.qm@web94916.mail.in2.yahoo.com>
References: <20100330122440.1e3d8bf1@lxorguk.ukuu.org.uk>
	<792863.15718.qm@web94916.mail.in2.yahoo.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The ST KIM module, is a platform device, which I use to pass the GPIO data from the arch/XX/board-XXX.c files, so, suppose we do have 2 devices for a platform, then I would need 2 platform devices right ?
> 
> And there-by can I use that platform device context ?

Yes or some struct created in the actual module and passed around in
preference to the platform device. A lot of kernel drivers end up
creating something per device that looks like

struct my_thing {
	struct device *dev;	/* or pci_dev etc */
	[ all my per device bits ]
};

and sometimes creating linked lists of them (for power management most
often)

> However the problem really is,
> 
> Suppose a BT driver wants to do an st_register() and use ST as its transport, how can I then tie it to a device ?

Not sure I follow

If you have some kind of context to kill off all the globals then you can
attach that to whatever local object you have for each device you are
interested in. That is why IRQ handlers pass a data value, why timers do,
why tty has ldisc_data, why workqueues do similar things and so on.

And if there is another layer you need to interface to which doesn't have
some kind of pointer for binding to layers above/below - add one.

