Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0EELFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 07:05:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53890 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751933Ab0EELFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 07:05:41 -0400
Date: Wed, 5 May 2010 12:11:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: pavan_savoy@ti.com
Cc: greg <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: GPS protocol driver for wl128x
Message-ID: <20100505121131.298e9445@lxorguk.ukuu.org.uk>
In-Reply-To: <114054.49943.qm@web94916.mail.in2.yahoo.com>
References: <114054.49943.qm@web94916.mail.in2.yahoo.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 May 2010 21:55:43 +0530 (IST)
Pavan Savoy <pavan_savoy@ti.com> wrote:

> Greg, Alan,
> 
> Just to complete the circle on N_TI_WL, find below the GPS driver which makes use of the shared transport line discipline.
> 
> This driver provides a TTY line character device to application/middle-ware running on host, as if the device is directly connected over UART to a GPS chip.

This doesn't appear to be a tty device ?

> Almost all actions that can be done on a /dev/ttySx can be done on this /dev/tigps device.

Hardly true. A tty driver has a very precisely defined set of behaviours
and a lot of ioctls and interfaces your driver doesn't. Our gps
interfaces are only tty drivers because historically they were plugged
into serial ports so I'm not sure the 'not a tty' bit actually matters.

Codewise its the same as all the rest - only one instance possible and
poking around in globals with no visible or documented locking.

