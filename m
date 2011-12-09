Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1LIOAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:00:06 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:49829 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab1LIOAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:00:03 -0500
Message-ID: <20194.5210.650914.867608@ipc1.ka-ro>
Date: Fri, 9 Dec 2011 14:59:54 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] flexcan: Acknowledge all interrupt sources in the IRQ
 handler
In-Reply-To: <4EE212AE.40005@pengutronix.de>
References: <1323438454-6816-1-git-send-email-LW@KARO-electronics.de>
	<4EE212AE.40005@pengutronix.de>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Marc Kleine-Budde writes:
> On 12/09/2011 02:47 PM, Lothar Waßmann wrote:
> > Otherwise the handler will get stuck in an endless IRQ loop when an
> > interrupt condition occurs that is not being acked (e.g. TWRN)
> 
> On which CPU do you have this problem?
> 
on i.MX28.

> Seems that mx25/35 behave a bit different than mx28. But I had no time
> to dig into this, yet. BTW Wolfgang is just reworking error handling,
> can you please test his patches he recently posted on linux-can.
> 
The ESR of i.MX25 is completely identical to the i.MX28.
You should be able to reproduce the problem when trying to send a
message to a CAN interface with the transceiver disabled.
You will get a BIT0_ERR and the TWRN bit will be asserted and never
cleared leading to an endless interrupt loop.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
