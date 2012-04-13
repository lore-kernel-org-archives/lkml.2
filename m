Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab2DMSOC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:14:02 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44847 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752927Ab2DMSOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:14:00 -0400
Date: Fri, 13 Apr 2012 14:13:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Johannes Stezenbach <js@sig21.net>
cc: Jason Baron <jbaron@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: ehci dynamic debug problem
In-Reply-To: <20120413174107.GA6021@sig21.net>
Message-ID: <Pine.LNX.4.44L0.1204131411010.1166-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012, Johannes Stezenbach wrote:

> > But there is no such thing as dynamic debug for ehci, is there?  
> > There's a separate dynamic debug setting for each dev_dbg statement.
> > So your ideal solution makes no sense.
> 
> When CONFIG_DYNAMIC_DEBUG=y but ehci debug is disabled

There is no such thing as ehci debug!  So how can it be disabled?
There's only an individual setting for each line of debugging code.

> in /sys/kernel/debug/dynamic_debug/control, then
> dbg_port() calls dbg_port_buf() which would
> format the string, then calls ehci_dbg() which
> calls dev_dbg() which discards it.
> 
> Does it make sense now?

No.  What happens if dynamic debug is enabled for one line that calls 
dbg_port_buf() but not for another?  There's no way to avoid the string 
formatting in both lines, even though one of them discards the result.

Alan Stern

