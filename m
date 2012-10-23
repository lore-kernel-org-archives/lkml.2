Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab2JWSlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:41:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56720 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622Ab2JWSlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:41:35 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 23 Oct 2012 20:41:11 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 0/1] staging: Add firewire-serial driver
Message-ID: <20121023204111.63e13986@stein>
In-Reply-To: <1351009822.2621.158.camel@thor>
References: <1350565015.23730.4.camel@thor>
	<20121022224505.GD24489@kroah.com>
	<1350959679.2621.55.camel@thor>
	<20121023105140.5996c3a5@pyramind.ukuu.org.uk>
	<1351009822.2621.158.camel@thor>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 23 Peter Hurley wrote:
> most controllers allow spillover into
> the portion of bus cycle assigned for sync tx (which is another 4Kbytes
> per 125us).

All controllers do so and are expected to do so.  Asynchronous traffic is
not supposed to depend on a cycle master being active.

> (Technical note: the actual total max for combined async
> and sync tx is 6144 bytes per 125us clock)

It depends on bus topology, transaction types, and more.  For a single-hop
S400 1394a bus (vulgo FireWire 400) I once calculated 44 MB/s bandwidth of
asynchronous unified write transactions:
http://marc.info/?l=linux1394-devel&m=109128028930225
That's at the physical layer; link layer and application layer performances
are less than that of course.
-- 
Stefan Richter
-=====-===-- =-=- =-===
http://arcgraph.de/sr/
