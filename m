Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366Ab2AIUHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 15:07:54 -0500
Received: from bues.ch ([80.190.117.144]:46464 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933137Ab2AIUHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 15:07:53 -0500
Date: Mon, 9 Jan 2012 21:07:33 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Incorrect uses of get_driver()/put_driver()
Message-ID: <20120109210733.17ae0983@milhouse>
In-Reply-To: <Pine.LNX.4.44L0.1201091438010.1541-100000@iolanthe.rowland.org>
References: <20120109181449.GF15083@core.coreip.homeip.net>
	<Pine.LNX.4.44L0.1201091438010.1541-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jan 2012 14:48:15 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> Maybe you want to call device_lock(&sdev->dev) here?  It will prevent
> the driver from being unbound (and therefore from being unloaded), and
> it's likely that sdrv's remove and probe routines expect to be called
> with this lock held, because that's what the device core does.  The
> drawback is that holding the lock prevents other things from happening
> as well, like unregistering sdev.
> 
> Alternatively, we can simply remove ssb_driver_get/put.

I think in practice it doesn't matter. This function is only
used in the rare case where the EEPROM on the board is written.

-- 
Greetings, Michael.
