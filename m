Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab2IKWCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:02:52 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:38306 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757983Ab2IKWCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:02:49 -0400
Date: Tue, 11 Sep 2012 22:02:48 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Felipe Balbi <balbi@ti.com>
cc: Greg KH <gregkh@linuxfoundation.org>, alan@linux.intel.com,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: [PATCH v4 00/21] OMAP UART Patches
In-Reply-To: <alpine.DEB.2.00.1209062137000.11516@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.00.1209112141220.9444@utopia.booyaka.com>
References: <20120906122948.GC29202@arwen.pp.htv.fi> <1346935540-1792-1-git-send-email-balbi@ti.com> <alpine.DEB.2.00.1209062137000.11516@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Felipe

Just tested these OMAP serial changes at commit 
e36851d0fa94b0f7802b3cc80406dbd3ef4f2f16 ("serial: omap: fix compile 
breakage").  There's good news and bad news...

The good news is that after applying this series, the 'OMAP4 UART garbage 
on long transmit buffers when PM is enabled' bug:

http://www.pwsan.com/omap/testlogs/test_v3.6-rc5/20120908202511/pm/4430es2panda/4430es2panda_log.txt

... goes away.  (Unclear if it's because the underlying bug was fixed, or 
if unrelated changes are masking it.)  Not sure what caused the problem to 
go away exactly, but it's one of the changes between d37c6ceb and bf63a08.  
So that's good!

The bad news is that N800 no longer boots -- or the UART dies during 
serial init:

http://www.pwsan.com/omap/testlogs/test_tty_next_e36851d0/20120910020323/boot/2420n800/2420n800_log.txt

The problem doesn't seem to affect the 2430SDP.

Could you put together a patch to fix N800?


regards

- Paul
