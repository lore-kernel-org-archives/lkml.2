Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab0FSUZz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 16:25:55 -0400
Received: from www.tglx.de ([62.245.132.106]:58743 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847Ab0FSUZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 16:25:53 -0400
From: John Ogness <john.ogness@linutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-arm-kernel@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>,
       Ivo Clarysse <ivo.clarysse@gmail.com>
Subject: Re: [PATCH 4/5] mtd: mxc_nand fixups
References: <804oh0b7gx.fsf@merkur.tec.linutronix.de>
	<20100618205401.GA12115@pengutronix.de>
Date: Sat, 19 Jun 2010 22:25:25 +0200
In-Reply-To: <20100618205401.GA12115@pengutronix.de> (Sascha Hauer's message
	of "Fri, 18 Jun 2010 22:54:01 +0200")
Message-ID: <80sk4ivkga.fsf@merkur.tec.linutronix.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-18, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>> This patch reverts the driver to enabling/disabling the NFC interrupt
>> mask rather than enabling/disabling the system interrupt. This cleans
>> up the driver so that it doesn't rely on interrupts being disabled
>> within the interrupt handler.
>
> This behaviour was introduced in
> a47bfd2eb66837653dc3b42541dfe4283dd41251 mxc_nand: support i.MX21
>
> I guess this won't work on i.MX21.

I just downloaded the i.MX21 reference manual and its NFC interrupts can
also be masked with INT_MASK (bit 4) of NFC_Flash_Config1 (0xdf003e1a).

IMHO we should revert the driver to masking the NFC interrupts. The
current linux-next version with nosync irq disabling within the
interrupt handler is a bit silly. Especially since the interrupt handler
does nothing except signal a wait queue.

John Ogness
