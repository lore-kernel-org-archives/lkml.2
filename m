Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab0FNJXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 05:23:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:35307 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab0FNJXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 05:23:34 -0400
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <19477.52889.982995.407051@ipc1.ka-ro>
References: <1275636608.606606.450179637764.0.gpush@pororo>
	 <201006111557.12249.jeremy.kerr@canonical.com>
	 <19473.61547.684572.647641@ipc1.ka-ro>
	 <201006111718.47426.jeremy.kerr@canonical.com>
	 <19474.172.742782.972629@ipc1.ka-ro>
	 <20100611095839.GC10894@pengutronix.de>
	 <19474.2817.333749.485028@ipc1.ka-ro> <1276319643.1962.181.camel@pasglop>
	 <19477.52889.982995.407051@ipc1.ka-ro>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 19:22:58 +1000
Message-ID: <1276507378.2552.39.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 08:39 +0200, Lothar Waßmann wrote:
> All implementations so far use spin_lock_irq_save()!

Nothing prevents your implementation to be a tad smarter.

> How would you be able to sleep with a mutex held?
> If you hold a lock you must not sleep, no matter what sort of lock it
> is. 

You can perfectly sleep with a mutex held. You -do- have to be careful
of course to ensure you aren't going to do silly thing like re-enter and
try to take it twice, or A->B B->A deadlocks, but in the typical case of
wanting to use a msleep rather than udelay, it works very well :-)

Cheers,
Ben.


