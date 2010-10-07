Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab0JGUgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:36:35 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10893 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab0JGUgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:36:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6129"; a="56986339"
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
From: Daniel Walker <dwalker@codeaurora.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Mike Frysinger <vapier@gentoo.org>, Feng Tang <feng.tang@intel.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
In-Reply-To: <20101007215019.17b4a34a@lxorguk.ukuu.org.uk>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
	 <20101007215019.17b4a34a@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 13:36:06 -0700
Message-ID: <1286483766.23836.39.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 21:50 +0100, Alan Cox wrote:
> > +	  Say Y here if you want to install DCC driver as a normal serial port
> > +	  /dev/ttyS0 (major 4, minor 64). Otherwise, it appears as /dev/ttyJ0
> > +	  (major 4, minor 128) and can co-exist with other UARTs, such as
> > +	  8250/16C550 compatibles.
> > +
> 
> NAK to both

Both what?

> ttyJ0 is 204,186 for "JTAG1 DCC protocol based serial"
> 
> so there is an existing name and minor allocation, which as you won't be
> using two of them should be quite usable.
> 
> If you want to be able to switch at runtime to pretend it is ttyS0 please
> deal with that in your user space. The same rules apply to you as have
> been applied to everyone else who has tried to implement this same crap
> in their uart driver too (we'd have it in about 30 by now otherwise)

I would agree if this wasn't strictly for debugging embedded devices in
difficult situations.. After talking to Mike, it's seems like it would
be useful to have this as a ttyS* specifically because embedded devices
won't always create a ttyJ* for you and ttyS* will likely already exist.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

