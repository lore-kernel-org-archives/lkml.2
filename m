Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab0HPERl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 00:17:41 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:55723 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab0HPERj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 00:17:39 -0400
Date: Mon, 16 Aug 2010 00:22:44 -0400
From: Andres Salomon <dilinger@queued.net>
To: David Miller <davem@davemloft.net>
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sparc: make driver/of/pdt no longer sparc-specific
Message-ID: <20100816002244.6ddf37e6@debxo>
In-Reply-To: <20100808.223444.62324566.davem@davemloft.net>
References: <20100808231116.21c7d6f3@dev.queued.net>
	<AANLkTimG7u5eXWSn5VznKfuFcFD+evTzo1_QpAFmCdpL@mail.gmail.com>
	<20100809013245.1cefb9bf@dev.queued.net>
	<20100808.223444.62324566.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Aug 2010 22:34:44 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Andres Salomon <dilinger@queued.net>
> Date: Mon, 9 Aug 2010 01:32:45 -0400
> 
> > On Sun, 8 Aug 2010 23:12:21 -0600
> > Grant Likely <grant.likely@secretlab.ca> wrote:
> > 
> >> If you have to explicitly cast these function pointers, then you're
> >> doing it wrong.  :-)  Listen to and fix the compiler complaint
> >> here.
> >> 
> > 
> > Hm, can you please expand on that?  The reason it's necessary to
> > cast is because sparc's prom_* functions are using ints instead of
> > phandles.  I don't understand why casting is the wrong thing here.
> > 
> > I could write some 1-line wrapper functions that simply call prom_*
> > rather than casting, I suppose.
> 
> There's no reason the Sparc interfaces can't take phandles since they
> are just ints, and that would make the call signatures of these
> functions compatible with the types used by the other architectures.

You're saying to convert the sparc code to use phandles?  Doing so has
caused phandles to show up in asm/openprom.h (linux_dev_v2_funcs's
v2_inst2pkg returns a phandle, and linux_nodeops use phandles).  This
is fine, except asm/openprom.h is an exported kernel header, and
linux/of.h is not.

I'm tempted to break the phandle/device_node/property stuff out into a
separate header (that gets exported), and include that from linux/of.h
and asm/openprom.h.
