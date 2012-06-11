Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab2FKQCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:02:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50545 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755558Ab2FKQCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:02:32 -0400
Date: Mon, 11 Jun 2012 12:02:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v2)
In-Reply-To: <CACVXFVNS2U-t7_8WwVNhQprP29y_xiZX25WwoBD5SRpch-p+7A@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206111202010.1607-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012, Ming Lei wrote:

> On Mon, Jun 11, 2012 at 10:16 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> >> +
> >> +             if (nonlocked)
> >> +                     dev_err(dev, "can't hold %slock for shutdown\n",
> >> +                                     nonlocked == 1 ? "" : "parent ");
> >
> > Even if the parent can't be locked, you should still try to lock the
> > device.
> 
> I have considered doing it, but which may consume another 1sec.
> 
> Also if the parent lock has been held, it is very possibly that the
> device can't be probed or removed at the same time, so just logged
> the crazy thing and go ahead.

Okay.  Then you can add my Acked-by.

Alan Stern

