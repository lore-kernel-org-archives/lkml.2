Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab0KOKCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:02:24 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:46187 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab0KOKCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:02:23 -0500
Date: Mon, 15 Nov 2010 19:01:50 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC 0/8] Dynamic clock devices
Message-ID: <20101115100150.GA25973@linux-sh.org>
References: <cover.1288897198.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1288897198.git.richard.cochran@omicron.at>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 08:26:34PM +0100, Richard Cochran wrote:
> Okay, here is a work in progress, not well tested, but I would like to
> get some feedback whether the direction is good or not.
> 
> The first patch introduces clock devices which can appear and
> disappear like usb devices (and, I suppose, hot plug PCI but I am not
> too sure that what is offered here would really work in that case).
> The subsequent patches convert the clock_ and timer_ system calls, one
> by one.
> 
Sorry to jump in late, but this only just caught my attention.

While I have no strong feelings on this series one way or the other, the
naming is a bit unfortunate. The clock device / clkdev naming is already
in use as an extension to the clock framework and is used by a wide
variety of embedded platforms already, with a pending patch to move it in
to the generic namespace (grepping for clkdev will give you an idea). The
idea behind that interface is similar in that it deals with the dynamic
creation and teardown of clocks, but is decoupled from timekeeping.

It's also reasonable to assume that devices with dynamic clocks tracked
through clkdev will wish to also use this interface in the timekeeping
case, so it would be good to settle on something less ambiguous in
advance.
