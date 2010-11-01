Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab0KAKFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 06:05:49 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:42659 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215Ab0KAKFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 06:05:47 -0400
Subject: Re: [PATCH 1/7] [AVR32] don't check platform_get_irq's return
 value against zero
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, David Vrabel <dvrabel@arcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>
In-Reply-To: <20101019064543.GA23839@pengutronix.de>
References: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <20101019064543.GA23839@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 01 Nov 2010 10:58:03 +0100
Message-ID: <1288605483.2843.71.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 01 Nov 2010 09:58:04.0405 (UTC) FILETIME=[46C7AA50:01CB79AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 08:45 +0200, Uwe Kleine-König wrote: 
> On Wed, Dec 16, 2009 at 05:10:03PM +0100, Uwe Kleine-König wrote:
> > platform_get_irq returns -ENXIO on failure, so !int_irq was probably
> > always true.  Better use (int)int_irq <= 0.  Note that a return value of
> > zero is still handled as error even though this could mean irq0.

Indeed, but external interrupts are numbered after the internal
interrupt lines, so in practice this does not happen. At least for now
with the AP700X series.

> > This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 that
> > changed the return value of platform_get_irq from 0 to -ENXIO on error.

Thanks for this fix.

> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Cc: David Vrabel <dvrabel@arcom.com>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

<snipp>

-- 
Hans-Christian Egtvedt

