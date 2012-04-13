Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab2DMTDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:03:20 -0400
Received: from bar.sig21.net ([80.81.252.164]:43559 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756144Ab2DMTDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:03:19 -0400
Date: Fri, 13 Apr 2012 21:03:11 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: ehci dynamic debug problem
Message-ID: <20120413190311.GA6238@sig21.net>
References: <20120413174107.GA6021@sig21.net>
 <Pine.LNX.4.44L0.1204131411010.1166-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1204131411010.1166-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 02:13:58PM -0400, Alan Stern wrote:
> On Fri, 13 Apr 2012, Johannes Stezenbach wrote:
> 
> > > But there is no such thing as dynamic debug for ehci, is there?  
> > > There's a separate dynamic debug setting for each dev_dbg statement.
> > > So your ideal solution makes no sense.
> > 
> > When CONFIG_DYNAMIC_DEBUG=y but ehci debug is disabled
> 
> There is no such thing as ehci debug!  So how can it be disabled?
> There's only an individual setting for each line of debugging code.
> 
> > in /sys/kernel/debug/dynamic_debug/control, then
> > dbg_port() calls dbg_port_buf() which would
> > format the string, then calls ehci_dbg() which
> > calls dev_dbg() which discards it.
> > 
> > Does it make sense now?
> 
> No.  What happens if dynamic debug is enabled for one line that calls 
> dbg_port_buf() but not for another?  There's no way to avoid the string 
> formatting in both lines, even though one of them discards the result.

That's why I said in my initial mail:

  Does dynamic debug offer an "is the message two lines below enabled" test?

What I meant is that dbg_port() could test if it
needs to call dbg_port_buf() for this call site.


Anyway, maybe the dbg_*_buf() are not called often enough to worry?

If you're OK with "#if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)"
then maybe you should just do that?


Thanks
Johannes
