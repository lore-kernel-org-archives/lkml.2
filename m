Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1ATVad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:30:33 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44189 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab1ATVab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:30:31 -0500
Date: Thu, 20 Jan 2011 16:30:27 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Ben Dooks <ben-linux@fluff.org>, Paul Mundt <lethal@linux-sh.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
In-Reply-To: <20110120185617.GI6335@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1101201623480.8580@xanadu.home>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111031552.GJ3760@linux-sh.org> <4D3862DB.5000708@fluff.org> <20110120185617.GI6335@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, Russell King - ARM Linux wrote:

> On Thu, Jan 20, 2011 at 04:29:15PM +0000, Ben Dooks wrote:
> > I really don't like the fact that people are doing these things in
> > atomic contexts, and I think we should apply some pressure to move
> > the atomic caller cases to use systems where they can sleep such as
> > using threaded-irq handlers (they work very nicely)
> 
> How do you ensure that printk is always called from a non-atomic
> context?

Is this a good example?  I don't think that power sensitive systems such 
as a cellphone should keep printk() enabled in the final product.  The 
output from printk() over a serial port is a debugging convenience, and 
trying to aggressively turn on/off the serial clock around each call to 
printk() is a bit silly.  Better simply turn the serial clock on 
whenever its console facility is opened, and turn it off when the 
console is closed, which should be good enough in that context.


Nicolas
