Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab0EFQGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:06:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43705 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754119Ab0EFQGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:06:34 -0400
Date: Thu, 6 May 2010 12:06:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Du, Alek" <alek.du@intel.com>
cc: Ondrej Zary <linux@rainbow-software.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: RE: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
In-Reply-To: <1865303E0DED764181A9D882DEF65FB61A82A6DAFD@shsmsx502.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.1005061204000.1708-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010, Du, Alek wrote:

> Hi Alan,
> 
> >With this patch, _none_ of the wakeup bits are enabled.  That should
> >work, right?
> >
> I guess so, but if no wakeup bits set, how to handle remote wakeup case? Seems you removed remote wakeup case?

The wakeup bits get set later, in ehci_set_wakeup_flags().

The point is that the wakeup bits take effect only when the controller 
leaves D0.  But ehci_bus_suspend() is called when the root hub is 
suspended, which happens first.  So at that time the wakeup bits aren't 
needed.

Alan Stern

