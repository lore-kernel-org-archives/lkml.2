Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab1EMVd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 17:33:56 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:48760 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab1EMVdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 17:33:55 -0400
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [RFC 2/5] gpio: add support for Technologic Systems TS-5500 GPIOs
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
In-reply-to: <20110430111536.5cb49d59@lxorguk.ukuu.org.uk>
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1304115712-5299-3-git-send-email-vivien.didelot@savoirfairelinux.com> <20110430111536.5cb49d59@lxorguk.ukuu.org.uk>
Date: Fri, 13 May 2011 17:33:52 -0400
Message-Id: <1305322106-sup-3383@v0nbox>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Alan Cox's message of sam avr 30 06:15:36 -0400 2011:
> > +    /* Enable IRQ generation */
> > +    mutex_lock(&drvdata->gpio_lock);
> > +    PORT_BIT_SET(0x7A, 7); /* DIO1_13 on IRQ7 */
> > +    PORT_BIT_SET(0x7D, 7); /* DIO2_13 on IRQ6 */
> > +    if (use_lcdio) {
> > +        PORT_BIT_CLEAR(0x7D, 4); /* Enable LCD header usage as DIO */
> > +        PORT_BIT_SET(0x7D, 6);   /* LCD_RS on IRQ1 */
> > +    }
> 
> What happens if an IRQ occurs at this point, you have no handler for it ?

The IRQ is just not handled. What would be the proper way to handle
that? Would it be possible to write those registers when the IRQ is
requested?

Thanks,
Vivien.
