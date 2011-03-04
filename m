Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744Ab1CDPEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:04:44 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:50977 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759734Ab1CDPEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:04:42 -0500
Date: Fri, 4 Mar 2011 10:04:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>, Randy Dunlap <randy.dunlap@oracle.com>
cc: lud <linux-usb@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: Tree for February 21 (usb/serial)
In-Reply-To: <20110303135152.c4b53da1.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.44L0.1103040953380.1812-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011, Randy Dunlap wrote:

> On Mon, 21 Feb 2011 21:30:01 +0100 Rafael J. Wysocki wrote:
> 
> > On Monday, February 21, 2011, Randy Dunlap wrote:
> > > On Mon, 21 Feb 2011 18:21:34 +1100 Stephen Rothwell wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > Changes since 20110218:
> > > 
> > > 
> > > When CONFIG_PM_RUNTIME is not enabled:
> > > 
> > > drivers/usb/serial/usb_wwan.c:702: error: 'struct dev_pm_info' has no member named 'usage_count'
> > 
> > This looks like a bug in the driver that shouldn't access this field directly.
> 
> 
> This build error is still with us in linux-next 2011.0303.

Since Oliver added this bug in commit
16871dcac74c63227aa92e0012f3004a648c2062 (usb_wwan: error case of
resume), he should be the person to fix it.  The logic there is not 
clear to me; I don't know how it ought to be changed.  Would replacing 
it with a call to usb_autopm_put_interface_no_suspend() be good enough?

Alan Stern

