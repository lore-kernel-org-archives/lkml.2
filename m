Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab1IPVWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 17:22:33 -0400
Received: from netrider.rowland.org ([192.131.102.5]:35880 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755995Ab1IPVWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 17:22:32 -0400
Date: Fri, 16 Sep 2011 17:22:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: Greg KH <gregkh@suse.de>, Michal Nazarewicz <mina86@mina86.com>,
        Klaus Schwarzkopf <schwarzkopf@sensortherm.de>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
In-Reply-To: <20110916171824.GA23338@linutronix.de>
Message-ID: <Pine.LNX.4.44L0.1109161720080.4044-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Sep 2011, Sebastian Andrzej Siewior wrote:

> * Greg KH | 2011-09-09 11:43:54 [-0700]:
> 
> >So we can expect more patches like this adding all of the possible
> >permutations of the different gadget devices?
> >
> >If so, ick, I thought that the work that was done was to prevent this
> >from happening, oh well :(
> 
> Would it be possible to come up with a gadget-hub driver which can have
> multiple gadget attached? This should get rid of this kind of gadget
> drivers, right?

Instead of implementing a hub, it might be possible to redo the 
composite driver in such a way that the individual function drivers are 
added as separate modules at runtime, rather than all bound together at 
compile time.

The details would be tricky, but I think it could be done.  One 
important point is that somehow you have to inform the composite core 
when all the function drivers have been loaded and initialized -- 
otherwise there's no way to tell when it's safe to enable the pull-ups 
and connect to the host.

Alan Stern

