Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474Ab2AIWo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:44:26 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49801 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932634Ab2AIWoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:44:25 -0500
Date: Mon, 9 Jan 2012 17:44:24 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Incorrect uses of get_driver()/put_driver()
In-Reply-To: <20120109210733.17ae0983@milhouse>
Message-ID: <Pine.LNX.4.44L0.1201091520360.1541-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jan 2012, Michael Büsch wrote:

> On Mon, 9 Jan 2012 14:48:15 -0500 (EST)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > Maybe you want to call device_lock(&sdev->dev) here?  It will prevent
> > the driver from being unbound (and therefore from being unloaded), and
> > it's likely that sdrv's remove and probe routines expect to be called
> > with this lock held, because that's what the device core does.  The
> > drawback is that holding the lock prevents other things from happening
> > as well, like unregistering sdev.
> > 
> > Alternatively, we can simply remove ssb_driver_get/put.
> 
> I think in practice it doesn't matter. This function is only
> used in the rare case where the EEPROM on the board is written.

Okay, then we can just remove those calls and not worry about it for
now, right?

Alan Stern

