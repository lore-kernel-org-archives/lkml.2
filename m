Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab0E1K62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 06:58:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:45474 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589Ab0E1K6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 06:58:23 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100528005045.6ea5feba@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org>
	 <20100527181433.GG3543@srcf.ucam.org>
	 <20100527200313.5c532f2f@lxorguk.ukuu.org.uk>
	 <201005280110.17075.rjw@sisk.pl>
	 <20100528005045.6ea5feba@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 09:29:57 +0200
Message-ID: <1275031797.32462.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 00:50 +0100, Alan Cox wrote:
> Today "idle" means "no task running"
> 
> If you are prepared to rephrase that as "no task that matters is running"
> what would need to answer ?

I'm not sure we need or want to go there.

Why not simply let upatedb block on its IO because its QoS policy tells
us that its IO priority is idle. Therefore it will not avoid the IO
device from going idle and indefinitely delaying servicing requests.

When updatedb blocks, the runqueue becomes empty and we gain goodness.

Or are we talking about the same thing?

