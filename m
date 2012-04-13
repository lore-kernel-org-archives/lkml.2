Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab2DMPTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 11:19:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51088 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751445Ab2DMPTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 11:19:38 -0400
Date: Fri, 13 Apr 2012 11:19:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Johannes Stezenbach <js@sig21.net>
cc: Jason Baron <jbaron@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: ehci dynamic debug problem
In-Reply-To: <20120413145728.GA22240@sig21.net>
Message-ID: <Pine.LNX.4.44L0.1204131110250.1163-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012, Johannes Stezenbach wrote:

> On Fri, Apr 13, 2012 at 10:35:59AM -0400, Alan Stern wrote:
> > On Fri, 13 Apr 2012, Johannes Stezenbach wrote:
> > > 
> > > Does dynamic debug offer an "is the message two lines below enabled" test?
> > > Simply changing the "#ifdef DEBUG" for dbg_port_buf()
> > > to "#if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)"
> > > is probably not acceptable due to the overhead of dbg_port_buf()?
> > 
> > I don't understand your question.  Doesn't dbg_port_buf need to be 
> > defined whenever dynamic debugging is enabled?
> > 
> > Alternatively, the definition of dbg_port_buf (and related routines) in 
> > the !defined(DEBUG) case could be changed; you could add
> > 
> > 	buf[0] = 0;
> > 
> > That way you wouldn't get garbage out, although you wouldn't get 
> > anything useful either.
> 
> The ideal solution I'm looking for gives useful output
> when dynamic debugging is enabled for ehci, but does no
> useless string formatting when CONFIG_DYNAMIC_DEBUG is y
> but the dynamic debug for ehci is disabled.

But there is no such thing as dynamic debug for ehci, is there?  
There's a separate dynamic debug setting for each dev_dbg statement.
So your ideal solution makes no sense.

Alan Stern

