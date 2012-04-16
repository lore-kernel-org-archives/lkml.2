Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2DPSKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:10:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab2DPSKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:10:37 -0400
Date: Mon, 16 Apr 2012 13:15:46 -0400
From: Jason Baron <jbaron@redhat.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: ehci dynamic debug problem
Message-ID: <20120416171546.GD2345@redhat.com>
References: <20120413174107.GA6021@sig21.net>
 <Pine.LNX.4.44L0.1204131411010.1166-100000@iolanthe.rowland.org>
 <20120413190311.GA6238@sig21.net>
 <20120416155423.GB2345@redhat.com>
 <20120416164139.GA14077@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416164139.GA14077@sig21.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 06:41:39PM +0200, Johannes Stezenbach wrote:
> On Mon, Apr 16, 2012 at 11:54:24AM -0400, Jason Baron wrote:
> > On Fri, Apr 13, 2012 at 09:03:11PM +0200, Johannes Stezenbach wrote:
> > > 
> > >   Does dynamic debug offer an "is the message two lines below enabled" test?
> > > 
> > 
> > Sorry was away for a bit...
> > 
> > dynamic debug doesn't offer any is enabled test, its hidden from the
> > user. That said, in this case, you can delay the printing to the buffer
> > with:
> ...
> > +	ehci_dbg (ehci, "%s\n", dbg_port_buf (_buf, sizeof _buf, label, port, status)); \
> 
> I think arguments are evaluated before dev_dbg is called so this
> won't help.
> 
> 

I looked at the disassembly - and this argument was in fact *not* evaluated
before the call. So I think this approach is worthwhile.

Thanks,

-Jason
