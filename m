Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab2DMRlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:41:24 -0400
Received: from bar.sig21.net ([80.81.252.164]:41654 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab2DMRlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:41:17 -0400
Date: Fri, 13 Apr 2012 19:41:07 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: ehci dynamic debug problem
Message-ID: <20120413174107.GA6021@sig21.net>
References: <20120413145728.GA22240@sig21.net>
 <Pine.LNX.4.44L0.1204131110250.1163-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1204131110250.1163-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 11:19:37AM -0400, Alan Stern wrote:
> On Fri, 13 Apr 2012, Johannes Stezenbach wrote:
> 
> > On Fri, Apr 13, 2012 at 10:35:59AM -0400, Alan Stern wrote:
> > > On Fri, 13 Apr 2012, Johannes Stezenbach wrote:
> > > > 
> > > > Does dynamic debug offer an "is the message two lines below enabled" test?
> > > > Simply changing the "#ifdef DEBUG" for dbg_port_buf()
> > > > to "#if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)"
> > > > is probably not acceptable due to the overhead of dbg_port_buf()?
> > > 
> > > I don't understand your question.  Doesn't dbg_port_buf need to be 
> > > defined whenever dynamic debugging is enabled?
> > > 
> > > Alternatively, the definition of dbg_port_buf (and related routines) in 
> > > the !defined(DEBUG) case could be changed; you could add
> > > 
> > > 	buf[0] = 0;
> > > 
> > > That way you wouldn't get garbage out, although you wouldn't get 
> > > anything useful either.
> > 
> > The ideal solution I'm looking for gives useful output
> > when dynamic debugging is enabled for ehci, but does no
> > useless string formatting when CONFIG_DYNAMIC_DEBUG is y
> > but the dynamic debug for ehci is disabled.
> 
> But there is no such thing as dynamic debug for ehci, is there?  
> There's a separate dynamic debug setting for each dev_dbg statement.
> So your ideal solution makes no sense.

When CONFIG_DYNAMIC_DEBUG=y but ehci debug is disabled
in /sys/kernel/debug/dynamic_debug/control, then
dbg_port() calls dbg_port_buf() which would
format the string, then calls ehci_dbg() which
calls dev_dbg() which discards it.

Does it make sense now?


Thanks,
Johannes
