Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab1C3PXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:23:11 -0400
Received: from tex.lwn.net ([70.33.254.29]:48806 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab1C3PXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:23:09 -0400
Date: Wed, 30 Mar 2011 09:23:07 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Luis Filipe Rossi <luisf.rossi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Help with dma on PCI driver
Message-ID: <20110330092307.4a8deb79@bike.lwn.net>
In-Reply-To: <AANLkTim3eMR+5VQT9Cbew70bLZ_3P7eo3FXx_TxMuP1=@mail.gmail.com>
References: <AANLkTim3eMR+5VQT9Cbew70bLZ_3P7eo3FXx_TxMuP1=@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.24.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 07:07:32 -0300
Luis Filipe Rossi <luisf.rossi@gmail.com> wrote:

> I am developing a driver for a custom PCI board. I am following the
> example on Essential Linux Device Drivers, but when i am calling the
> pci_alloc_consitent i get the following error:
> Mar 29 15:18:42 luis-desktop kernel: [ 4520.075823] BUG: unable to
> handle kernel NULL pointer dereference at 00000004

Your source was horribly mangled, which is likely to reduce the number of
responses you get.  I've not had the time to look at it in great detail,
but I will say that the assumption that the PCI device is already probed
and registered immediately after the pci_register_driver() call is
dangerous at best.  Things like dma_descriptor_setup() should be called in
your probe routine (or even later, when you actually need the buffer)
rather than in your module init function.

There's a lot of other issues with this driver, but that's the one I would
look first at for the resolution of this particular crash.

jon
