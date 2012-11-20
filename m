Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab2KTQJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:09:40 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41054 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753405Ab2KTQJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:09:38 -0500
Date: Tue, 20 Nov 2012 11:09:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: harvey yang <harvey.huawei.yang@gmail.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] usb: add 'usb_get_intf()' call into the probe methods of
 drivers for usb interfaces.
In-Reply-To: <CAFCUKTS=SHoD4jpJe0_H6tsKcw-C9bAQP=VhXx+Lp8WZ4Xj6cA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1211201104550.1692-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2012, harvey yang wrote:

> Hi, all
> I checked many usb drivers in the mainline kernel which do not record
> this reference in their probe methods. But according to the documents
> about this function, we shoud record this reference in our probe
> methods, just as the call to 'usb_get_dev()' to reference a usb
> device. Are these usb drivers right or we need to fix them?

The drivers are right; they do not need to be fixed.  The reason is
because the drivers will be unbound automatically when the device or
interface is unregistered.

The only reason for a driver to take a reference would be if it wanted 
to continue using the device after it was unbound.  But drivers aren't 
supposed to do that.

Alan Stern

