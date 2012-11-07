Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab2KGV4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 16:56:51 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51223 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753220Ab2KGV4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 16:56:50 -0500
Date: Wed, 7 Nov 2012 16:56:49 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Huang Ying <ying.huang@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
In-Reply-To: <5835880.VrlCHNcBeW@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1211071653140.1188-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012, Rafael J. Wysocki wrote:

> > Right.  The reasoning behind my proposal goes like this: When there's
> > no driver, the subsystem can let userspace directly control the
> > device's power level through the power/control attribute.
> 
> Well, we might as well just leave the runtime PM of PCI devices enabled, even
> if they have no drivers, but modify the PCI bus type's runtime PM callbacks
> to ignore devices with no drivers.
> 
> IIRC the reason why we decided to disable runtime PM for PCI device with no
> drivers was that some of them refused to work again after being put by the
> core into D3.  By making the PCI bus type's runtime PM callbacks ignore them
> we'd avoid this problem without modifying the core's behavior.

It comes down to a question of the parent.  If a driverless PCI device
isn't being used, shouldn't its parent be allowed to go into runtime
suspend?  As things stand now, we do allow it.

The problem is that we don't disallow it when the driverless device
_is_ being used.

Alan Stern

