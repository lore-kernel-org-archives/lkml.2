Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab2DMTky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:40:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50944 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755669Ab2DMTkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:40:53 -0400
Date: Fri, 13 Apr 2012 15:40:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Johannes Stezenbach <js@sig21.net>
cc: Jason Baron <jbaron@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: ehci dynamic debug problem
In-Reply-To: <20120413190311.GA6238@sig21.net>
Message-ID: <Pine.LNX.4.44L0.1204131539280.1146-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012, Johannes Stezenbach wrote:

> > > Does it make sense now?
> > 
> > No.  What happens if dynamic debug is enabled for one line that calls 
> > dbg_port_buf() but not for another?  There's no way to avoid the string 
> > formatting in both lines, even though one of them discards the result.
> 
> That's why I said in my initial mail:
> 
>   Does dynamic debug offer an "is the message two lines below enabled" test?
> 
> What I meant is that dbg_port() could test if it
> needs to call dbg_port_buf() for this call site.

Oh.  As far as I know, that's not possible.

> Anyway, maybe the dbg_*_buf() are not called often enough to worry?

Probably not.

> If you're OK with "#if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)"
> then maybe you should just do that?

Yes, that sounds best.

Alan Stern

