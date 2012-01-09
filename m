Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab2AIXFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 18:05:30 -0500
Received: from bues.ch ([80.190.117.144]:46792 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab2AIXF3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 18:05:29 -0500
Date: Tue, 10 Jan 2012 00:05:19 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Incorrect uses of get_driver()/put_driver()
Message-ID: <20120110000519.3d17e64e@milhouse>
In-Reply-To: <Pine.LNX.4.44L0.1201091520360.1541-100000@iolanthe.rowland.org>
References: <20120109210733.17ae0983@milhouse>
	<Pine.LNX.4.44L0.1201091520360.1541-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jan 2012 17:44:24 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Mon, 9 Jan 2012, Michael Büsch wrote:
> 
> > On Mon, 9 Jan 2012 14:48:15 -0500 (EST)
> > Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > Maybe you want to call device_lock(&sdev->dev) here?  It will prevent
> > > the driver from being unbound (and therefore from being unloaded), and
> > > it's likely that sdrv's remove and probe routines expect to be called
> > > with this lock held, because that's what the device core does.  The
> > > drawback is that holding the lock prevents other things from happening
> > > as well, like unregistering sdev.
> > > 
> > > Alternatively, we can simply remove ssb_driver_get/put.
> > 
> > I think in practice it doesn't matter. This function is only
> > used in the rare case where the EEPROM on the board is written.
> 
> Okay, then we can just remove those calls and not worry about it for
> now, right?

This would be acceptable.

-- 
Greetings, Michael.
