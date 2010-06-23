Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab0FWJX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 05:23:59 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:36589 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0FWJX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 05:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eWcf0/dYuux3shUDZ52neOdiQRNxtd7MAYmbn5VccOc60nrnArqzS6I9jo5PLbDNBt
         pErGsneS4xowzF+YYcpJH5ToUW3Lmugm76/rJCsXNJfZS73MB5TUyhYP8sXPJMY8nhfd
         V0zQsewDdApUYnKxian1ZGIIbBm0JUn0pRr0I=
MIME-Version: 1.0
In-Reply-To: <80vd9ab0d2.fsf@merkur.tec.linutronix.de>
References: <804oh0b7gx.fsf@merkur.tec.linutronix.de>
	<20100618205401.GA12115@pengutronix.de>
	<80sk4ivkga.fsf@merkur.tec.linutronix.de>
	<AANLkTimA7Rbm_nHpVYpEPqaPCjrOse9s8YyiInWlhfEK@mail.gmail.com>
	<80tyoyhxey.fsf_-_@merkur.tec.linutronix.de>
	<AANLkTikRj_dMkKLyFhW78yld9jIYAIFncfPaPAF8WqUY@mail.gmail.com>
	<80iq5bqd07.fsf_-_@merkur.tec.linutronix.de>
	<AANLkTimJKNEwOoKldq4a4_ufxNY6IY7r6tAfAM055hlW@mail.gmail.com>
	<80vd9ab0d2.fsf@merkur.tec.linutronix.de>
Date: Wed, 23 Jun 2010 11:23:55 +0200
Message-ID: <AANLkTinVaXjCneg-XpxB7YNlmGOwQFTnm5RUcetPdToI@mail.gmail.com>
Subject: Re: [PATCHv3 4/5] mtd: mxc_nand fixups
From: Ivo Clarysse <ivo.clarysse@gmail.com>
To: John Ogness <john.ogness@linutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Sascha Hauer <kernel@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 10:48 AM, John Ogness <john.ogness@linutronix.de> wrote:
[...]
>
> OK. Now I understand the problem. Here is a new patch that introduces a
> flag that is set by the interrupt handler. This way we do not rely on
> the i.MX21 being able to read NFC_INT when the interrupt is masked.

Yes, this works on i.MX21 (tested on an MX21ADS board).

[...]
> @@ -117,6 +118,7 @@ struct mxc_nand_host {
>        int                     clk_act;
>        int                     irq;
>
> +       int                     nfc_int;

But is it OK to use a regular (non-volatile) variable to communicate
between interrupt context and the non-interrupt context ?

My original patch for i.MX21 used completions instead:

http://lists.infradead.org/pipermail/linux-arm-kernel/2010-April/012694.html
