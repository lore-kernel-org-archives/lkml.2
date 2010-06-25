Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab0FYOuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:50:52 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:54208 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab0FYOuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 10:50:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SovpteFCyRsq3MqHN8gN1Gvf+CzgHjzTW9ySImjWM0WFE2trboAbWWryo7hIzbOf9f
         a71N8s63/fEZT9/2qOWOD10CEUD2bHXVrKMqJf8Kr+YLlnVc+UJfDDm5xyObeytLmNKf
         HNxhUxUvLd23OBNC8HfH8WxF06W+dmfRn099c=
MIME-Version: 1.0
In-Reply-To: <807hloag6w.fsf@merkur.tec.linutronix.de>
References: <20100618205401.GA12115@pengutronix.de>
	<80sk4ivkga.fsf@merkur.tec.linutronix.de>
	<AANLkTimA7Rbm_nHpVYpEPqaPCjrOse9s8YyiInWlhfEK@mail.gmail.com>
	<80tyoyhxey.fsf_-_@merkur.tec.linutronix.de>
	<AANLkTikRj_dMkKLyFhW78yld9jIYAIFncfPaPAF8WqUY@mail.gmail.com>
	<80iq5bqd07.fsf_-_@merkur.tec.linutronix.de>
	<AANLkTimJKNEwOoKldq4a4_ufxNY6IY7r6tAfAM055hlW@mail.gmail.com>
	<80vd9ab0d2.fsf@merkur.tec.linutronix.de>
	<AANLkTinVaXjCneg-XpxB7YNlmGOwQFTnm5RUcetPdToI@mail.gmail.com>
	<80lja6awlb.fsf@merkur.tec.linutronix.de>
	<20100624072732.GQ12115@pengutronix.de>
	<807hloag6w.fsf@merkur.tec.linutronix.de>
Date: Fri, 25 Jun 2010 16:50:45 +0200
Message-ID: <AANLkTilTbvlPxRhioMiKrBUNggcxZeboi1YpB8Y9Bdpm@mail.gmail.com>
Subject: Re: [PATCHv3 4/5] mtd: mxc_nand fixups
From: Ivo Clarysse <ivo.clarysse@gmail.com>
To: John Ogness <john.ogness@linutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-arm-kernel@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 12:16 PM, John Ogness <john.ogness@linutronix.de> wrote:
> On 2010-06-24, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>> Ok, if it's the only way out to have 5 cpu_is_* blocks, then lets go
>> for it.
>
> Here is a new patch that puts the behavior behind a "nfc_avoid_masking"
> macro. The macro is only used 3 times.
[...]

Tested on an MX21ADS board, and it still works.

> This patch is based on linux-next 20100618.
>
> Signed-off-by: John Ogness <john.ogness@linutronix.de>
> ---
>  drivers/mtd/nand/mxc_nand.c |   81 +++++++++++++++++++++++++---------
>  1 file changed, 61 insertions(+), 20 deletions(-)
>
> Index: linux-next-20100618/drivers/mtd/nand/mxc_nand.c
> ===================================================================
> --- linux-next-20100618.orig/drivers/mtd/nand/mxc_nand.c
> +++ linux-next-20100618/drivers/mtd/nand/mxc_nand.c
[...]
> @@ -100,6 +109,18 @@
>
>  #define NFC_RSLTSPARE_AREA_MASK  0xff
>
> +#define nfc_interrupt_set(_regs) \
> +               (readw(_regs + NFC_CONFIG2) & NFC_INT)
> +#define nfc_clear_interrupt(_regs) \
> +               writew(readw(_regs + NFC_CONFIG2) & ~NFC_INT, \
> +                      _regs + NFC_CONFIG2)

Naming is not very consistent; I'd suggest nfc_set_interrupt /
nfc_clear_interrupt

> +#define nfc_mask_irq(_regs) \
> +               writew(readw(_regs + NFC_CONFIG1) | NFC_INT_MSK, \
> +                      _regs + NFC_CONFIG1)
> +#define nfc_unmask_irq(_regs) \
> +               writew(readw(_regs + NFC_CONFIG1) & ~NFC_INT_MSK, \
> +                      _regs + NFC_CONFIG1)
> +
[...]
