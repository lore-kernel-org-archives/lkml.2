Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1DKJit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 05:38:49 -0400
Received: from portal.weinmann.de ([62.8.140.122]:5168 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab1DKJis convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 05:38:48 -0400
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'Nicolas Ferre'" <nicolas.ferre@atmel.com>
CC: "'Linux Kernel'" <linux-kernel@vger.kernel.org>
Date: Mon, 11 Apr 2011 11:38:34 +0200
Subject: RE: [PATCH] drivers/spi/atmel_spi.c: prevent premature irqs
Thread-Topic: [PATCH] drivers/spi/atmel_spi.c: prevent premature irqs
Thread-Index: Acv4JYBfSrGbB5yuT9KWjA19zDVBwwABI0gg
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D086F9314A4@wm021.weinmann.com>
References: <EF2E73589CA71846A15D0B2CDF79505D086F931361@wm021.weinmann.com>
 <4DA2C0C0.6050903@atmel.com>
In-Reply-To: <4DA2C0C0.6050903@atmel.com>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> What about something like this?
> 
> /* disable all interrupts to avoid premature irq triggering */
> spi_writel(as, IDR, 0xffffffff);

I implemented it this way the first time, but on a second approach I used
the more specific variant.

That way it is kept symmetric to the irq enable part in the transfer method
which enables no more than the irqs disabled in my patch. And I generally
feel better when not writing live values to don't care bits ;-).

It's a matter of taste after all.

Best regards,
Nikolaus Voss

