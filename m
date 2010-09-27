Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907Ab0I0IQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:16:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46351 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab0I0IQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E+mt7bVyw0FZvutHm51kYt19X/mg+vneod99e4LmM9PUVYLVD+/LRjvRp4Ip3lixmA
         7DVYVcP1yM/nwnO7Sh+qmWxA0zCXl6E152phwr8Ghtllo2sgFu94ariVdNbDgxtYhcyG
         yPL60XFRcEgx05hlcTCxb+3GQUnsjge++3baI=
MIME-Version: 1.0
In-Reply-To: <20100924141046.GA26454@sirena.org.uk>
References: <AANLkTin9Qji_bdyd3yqrP_-ti5xRT9jJ4je2fPM=uHFX@mail.gmail.com>
	<20100924141046.GA26454@sirena.org.uk>
Date: Mon, 27 Sep 2010 10:16:11 +0200
Message-ID: <AANLkTin=PPfgnD5tKBPR1QXf2OeBKBH-kXtoT+s-KPhk@mail.gmail.com>
Subject: Re: [PATCH 1/6] This patch adds support for the ST-Ericsson CG2900
From: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Pavan Savoy <pavan_savoy@sify.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again Mark,

I've not got an answer from the developer of the particular piece of code.

2010/9/24 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Sep 24, 2010 at 03:46:44PM +0200, Par-Gunnar Hjalmdahl wrote:
>
>> +static irqreturn_t cg2900_devices_interrupt(int irq, void *dev_id)
>> +{
>> +     disable_irq_nosync(irq);
>> +     if (cg2900_dev_callback && cg2900_dev_callback->interrupt_cb)
>> +             cg2900_dev_callback->interrupt_cb();
>> +
>> +     return IRQ_HANDLED;
>> +}
>
> Why is there this callback mechanism - I'd expect the users of this code
> to just be using the standard IRQ infrastructure?
>

This is our local IRQ which is handled in cg2900_uart.c by creating a work:

static void cg2900_devices_irq_cb(void)
{
 /* Create work and leave irq context. */
 (void)create_work_item(uart_info->wq, handle_cts_irq, NULL);
}


I understand your concern that client implementing the
cg2900_dev_callback->interrupt_cb();
might not know realized that this is irq context which might cause problems.

My motivation for doing like this that we do not expect other clients
of this code, so there
is no such risk. We create work in cg2900_uart and leave function.

Let me know if it is ok.
If not then suggest what is expected way of handling it ? eg. moving
workqueue down to cg2900_devices
or other solution?

Best regards,
/Lukasz via P-G
