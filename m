Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1LFVtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:49:06 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35342 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754799Ab1LFVtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:49:03 -0500
X-Sasl-enc: StQsMigZrno9YzG1DJeEpMZLsksPoDlrcpddK8VWjIhU 1323208142
Date: Tue, 6 Dec 2011 13:48:47 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, NeilBrown <neilb@suse.de>,
        Ming Lei <tom.leiming@gmail.com>,
        Chen Peter-B29397 <B29397@freescale.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        "hzpeterchen@gmail.com" <hzpeterchen@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: Re: [PATCH] Driver core: leave runtime PM enabled during system
 shutdown
Message-ID: <20111206214847.GH1247@kroah.com>
References: <201112052332.10822.rjw@sisk.pl>
 <Pine.LNX.4.44L0.1112061024240.1469-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1112061024240.1469-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 10:26:14AM -0500, Alan Stern wrote:
> Disabling all runtime PM during system shutdown turns out not to be a
> good idea, because some devices may need to be woken up from a
> low-power state at that time.
> 
> The whole point of disabling runtime PM for system shutdown was to
> prevent untimely runtime-suspend method calls.  This patch (as1504)
> accomplishes the same result by incrementing the usage count for each
> device and waiting for ongoing runtime-PM callbacks to finish.  This
> is what we already do during system suspend and hibernation, which
> makes sense since the shutdown method is pretty much a legacy analog
> of the pm->poweroff method.
> 
> This fixes a regression on some OMAP systems.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Reported-by: NeilBrown <neilb@suse.de>
> CC: Chen Peter-B29397 <B29397@freescale.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Rafael, you will take this in your tree, right?

