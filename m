Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab1CGTru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:47:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834Ab1CGTrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:47:49 -0500
Subject: Re: Network link detection
From: Dan Williams <dcbw@redhat.com>
To: Nico =?ISO-8859-1?Q?Sch=FCmann?= <dev@nico22.de>
Cc: David Miller <davem@davemloft.net>, chris.friesen@genband.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 07 Mar 2011 13:49:08 -0600
In-Reply-To: <20110303222957.GA30472@svh.nico22.de>
References: <20110303193006.GA29129@svh.nico22.de>
	 <4D700A5B.2000807@genband.com>
	 <20110303.140106.191399853.davem@davemloft.net>
	 <20110303222957.GA30472@svh.nico22.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <1299527350.3269.11.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 23:29 +0100, Nico Schümann wrote:
> On Thu, Mar 03, 2011 at 02:01:06PM -0800, David Miller wrote:
> > From: Chris Friesen <chris.friesen@genband.com>
> > Date: Thu, 03 Mar 2011 15:38:35 -0600
> > 
> > > You might look at whether you could write a kernel module to register
> > > for NETDEV_CHANGE notifications and pass that back to userspace.
> > 
> > This is the kind of responses you get when you ask networking specific
> > questions and don't CC: netdev :-/
> > 
> 
> Thank you for CC.
> 
> > There is this thing called netlink, you can listen for arbitrary
> > network state change events on a socket, and get the link state
> > notifications you are looking for.  It's in use by many real
> > applications like NetworkManager and co.
> 
> That really looks like what I'm looking for. I was already wondering 
> where NetworkManager gets the link state changes from, but I just 
> expected it to poll. So now I'll read a bit of documentation and 
> hopefully get it work.

http://cgit.freedesktop.org/NetworkManager/NetworkManager/tree/src/nm-netlink-monitor.c

NM uses libnl as the basic library for parsing netlink messages and
handling communication with the kernel.  Which is why you'll see a lot
of nl_* calls in there.  NM sets up the netlink connection using libnl,
then creates a GIOChannel to handle communication over the netlink
socket.  When something comes in (to event_handler()) the code handles
error conditions on the socket, then dispatches to libnl for processing.
libnl then calls back into NM to handle the actual message in
event_msg_ready().

Dan


