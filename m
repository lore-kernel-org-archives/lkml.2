Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab0FULrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 07:47:47 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:36048 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344Ab0FULro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 07:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y8+HHe5MrZ886MbYZWIQ8zDf2QBbl+ct0GxngSYmkrhY3B//fi3m99B4lxiXCxahDj
         KelfDRddud9YA5Ao+Z/SQ+SmOOPxuO1rlnqpeAeINdBk7YyyyNSEPw9MojABB2YaGBDg
         bom2/zxQzNmX+EsRx1ddOdruyQVdVZwR4F2Sw=
MIME-Version: 1.0
In-Reply-To: <80tyoyhxey.fsf_-_@merkur.tec.linutronix.de>
References: <804oh0b7gx.fsf@merkur.tec.linutronix.de>
	<20100618205401.GA12115@pengutronix.de>
	<80sk4ivkga.fsf@merkur.tec.linutronix.de>
	<AANLkTimA7Rbm_nHpVYpEPqaPCjrOse9s8YyiInWlhfEK@mail.gmail.com>
	<80tyoyhxey.fsf_-_@merkur.tec.linutronix.de>
Date: Mon, 21 Jun 2010 13:47:41 +0200
Message-ID: <AANLkTikRj_dMkKLyFhW78yld9jIYAIFncfPaPAF8WqUY@mail.gmail.com>
Subject: Re: [PATCHv2 4/5] mtd: mxc_nand fixups
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

On Sun, Jun 20, 2010 at 11:21 AM, John Ogness <john.ogness@linutronix.de> wrote:
>
> On 2010-06-20, Ivo Clarysse <ivo.clarysse@gmail.com> wrote:
> > Yes, on i.MX21, NFC interrupts can be masked using
> > NFC_CONFIG1:NFC_INT_MSK.  But I observed that as long as NFC_INT_MSK
> > is set, NFC_CONFIG2:NFC_INT will always read out 0 on i.MX21, even if
> > the operation is completed.
> >
> > So the driver will remain stuck at:
> >
> >                  wait_event(host->irq_waitq,
> >                          readw(host->regs + NFC_CONFIG2) & NFC_INT);
>
> OK. Here is alternative patch. Do you have access to an i.MX21 to test
> this on?
>
> This patch fixes the driver so that the irq is requested as disabled. This
> prevents double irq enabling and also does not require the interrupt to
> be disabled within the interrupt handler. (Actually, I beleive this was
> the true intention of the original author.)
[...]

Yes, that was indeed my true intention :)

I tested this change on an MX21ADS board.

Acked-by: Ivo Clarysse <ivo.clarysse@gmail.com>
