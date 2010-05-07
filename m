Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0EGNl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 09:41:58 -0400
Received: from mga10.intel.com ([192.55.52.92]:58368 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754389Ab0EGNl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 09:41:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,348,1270450800"; 
   d="scan'208";a="796348276"
Date: Fri, 7 May 2010 14:02:48 +0100
From: Alan Cox <alan@linux.intel.com>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Driver for a SmartCard interface on a SoC
Message-ID: <20100507140248.7958da8f@linux.intel.com>
In-Reply-To: <201005071518.50406.jbe@pengutronix.de>
References: <201005071518.50406.jbe@pengutronix.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 May 2010 15:18:50 +0200
Juergen Beisert <jbe@pengutronix.de> wrote:

> Hi,
> 
> most SmartCard readers are external devices, connected via USB or
> serial lines. So, they do not need special in-kernel drivers.
> 
> My SmartCard interface is part of a SoC (i.MX25 CPU). So, I need an
> in-kernel driver. Where would be the best place in the kernel tree,
> to add a driver for this kind of device? Maybe "drivers/char"?
> To exchange data with the plugged in SmartCard, only a couple of
> IOCTLs are required (detecting if a card is plugged in, socket power
> on/off, send reset to the card, configuring the communication
> parameters). Data exchange with the SmartCard can be done with simple
> read/write.

I'd say drivers/char if its a generic char device, but if its MX25
specific code entirely then drivers/platform or arch/.../platform.

The other question is one of API - it's going to best if the API isn't
MX25 specific but could reasonably be expected to work with other
future devices. A fake tty interface is probably overkill for that but
it would be good to get general review of any API.
