Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab0EGBfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 21:35:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:47511 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab0EGBfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 21:35:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,344,1270450800"; 
   d="scan'208";a="515826042"
Date: Fri, 7 May 2010 09:32:00 +0800
From: "Du, Alek" <alek.du@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Ondrej Zary <linux@rainbow-software.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
Message-ID: <20100507093200.28ecd63c@dxy2>
In-Reply-To: <Pine.LNX.4.44L0.1005061204000.1708-100000@iolanthe.rowland.org>
References: <1865303E0DED764181A9D882DEF65FB61A82A6DAFD@shsmsx502.ccr.corp.intel.com>
	<Pine.LNX.4.44L0.1005061204000.1708-100000@iolanthe.rowland.org>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 May 2010 00:06:33 +0800
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Thu, 6 May 2010, Du, Alek wrote:
> 
> > Hi Alan,
> > 
> > >With this patch, _none_ of the wakeup bits are enabled.  That should
> > >work, right?
> > >
> > I guess so, but if no wakeup bits set, how to handle remote wakeup case? Seems you removed remote wakeup case?
> 
> The wakeup bits get set later, in ehci_set_wakeup_flags().
> 
> The point is that the wakeup bits take effect only when the controller 
> leaves D0.  But ehci_bus_suspend() is called when the root hub is 
> suspended, which happens first.  So at that time the wakeup bits aren't 
> needed.
> 
> Alan Stern
> 

Alan,

As I tested, with the second patch, after entering phy low power mode, the port cannot detect any USB devices that plugged in.
I also confirm that after set PHCD flag, any write to PORTSC is illegal. (I have another patch will send out soon named "Clear PHCD before resuming",
but the patch is not related with this one) 

So it seems wakeup bits must set before set PHCD. So we may revise the flowchart a little bit, for example, if the HCD has hostpc,
then set the wakeup bits like before, if the HCD is the normal one, then go your new way?


Thanks,
Alek
