Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab1HEUoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 16:44:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52966 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750827Ab1HEUoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 16:44:07 -0400
Date: Fri, 5 Aug 2011 16:44:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jesper Juhl <jj@chaosbits.net>, Len Brown <len.brown@intel.com>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Crash when suspending Lenovo T510 laptop (2.6.39.3)
In-Reply-To: <201108052236.12404.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1108051641040.2055-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Aug 2011, Rafael J. Wysocki wrote:

> > You're right, sorry.  System suspend was not involved, so the problem
> > was triggerend by runtime suspend alone, resulting from unplugging the
> > Ethernet cable.
> > 
> > It looks like the crash started in pci_disable_msi().
> 
> OTOH, I'm not sure how pci_legacy_suspend_late() was called.
> In theory it is only called by the system suspend code and it surely
> is not called for e1000e.

The ? indicates that pci_legacy_suspend_late() wasn't necessarily on
the task's call stack; it may simply have been a leftover pointer from
some other operation, sitting somewhere in the middle of the stack
page.

Alan Stern

