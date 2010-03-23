Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab0CWUYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 16:24:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39450 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751722Ab0CWUYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 16:24:32 -0400
Date: Tue, 23 Mar 2010 20:28:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pavan Savoy <pavan_savoy@ti.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] drivers:misc: sources for ST core
Message-ID: <20100323202821.22f7c7f0@lxorguk.ukuu.org.uk>
In-Reply-To: <420891.23395.qm@web94909.mail.in2.yahoo.com>
References: <4BA8E158.6040102@ti.com>
	<420891.23395.qm@web94909.mail.in2.yahoo.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > [alan]
> > >What if you have multiple devices at once one in each
> > state ?
> > >Why is this global ?
> > 
> > [pavan]
> > st_gdata required in non-tty calls as well.
> > 
> > [pavan]
> > Can't happen, The chip on doing a UART write will either
> > write whole of BT data or whole of FM, so it can't be in
> > multiple states.

What if you have two chips ?

> > st_gdata not in tty priv data or ldisc_data because there
> > are entry points like st_register/unregister which are
> > EXPORTed requires it.

We need to fix that I think so there is some kind of context that is per
device.

> > If the rest seems fine, please consider it for staging,
> > Will keep reworking on it.

I'm happy with it going that way and that means I can then send patches
and suggestions to clean it up bit by bit.
