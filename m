Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441Ab0FEOKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 10:10:43 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:54209 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933424Ab0FEOKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 10:10:39 -0400
Date: Sat, 5 Jun 2010 15:10:31 +0100
From: Marc Zyngier <maz@misterjones.org>
To: Esben Haabendal <esbenhaabendal@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Esben Haabendal <eha@doredevelopment.dk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, joachim.eastwood@jotron.com
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded 
 interrupt handlers
Message-ID: <20100605151031.2d562268@hina.wild-wind.fr.eu.org>
In-Reply-To: <AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk>
	<alpine.LFD.2.00.1006042343150.2933@localhost.localdomain>
	<AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.12.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 93.97.26.37
X-SA-Exim-Rcpt-To: esbenhaabendal@gmail.com, tglx@linutronix.de, eha@doredevelopment.dk, linux-kernel@vger.kernel.org, mingo@elte.hu, joachim.eastwood@jotron.com
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010 15:56:01 +0200
Esben Haabendal <esbenhaabendal@gmail.com> wrote:

> I have a board with an I2C PCA9535 chip with two PHY interrupt lines
> hooked up to. The pca953x driver calls set_irq_nested_thread on all
> irq's on initialization. The PHY driver then calls request_irq, and has
> no idea that it should actually be using a threaded handler.
> 
> With this patch, the PHY driver is able to work in this scenario
> without changes (and so should any other driver using request_irq).

You may want to give request_any_context_irq() a try (available since the
latest merge window). It still requires your driver to be changed, but it
should then work in both threaded and non-threaded cases.

	M.
-- 
Enforcement officers may use a hand-held detection device to measure both
the direction and the strength of a TV signal. This makes it easy for us
to locate TV receiving equipment in even the hardest-to-reach places.
