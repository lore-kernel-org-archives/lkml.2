Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab0L3G1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 01:27:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35797 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab0L3G1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 01:27:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=bIXsZlqu8IPxNFVH5Ib6ObqnESLbQ4dTSNnaWHGafxm/THn4EeQR/gnESfqF+Li2yz
         idwhywkn+xVR/1ONAn8+cO6AOaIko1SXCDDsIx+BQHJtSXAFnufo6MCfWRttkJfai6dU
         Uq4GOHnj5q/n6MTKqr+g4l7yvSxlvYbObjyIU=
MIME-Version: 1.0
In-Reply-To: <1293686960-12581-1-git-send-email-adharmap@codeaurora.org>
References: <1293686960-12581-1-git-send-email-adharmap@codeaurora.org>
Date: Thu, 30 Dec 2010 11:57:23 +0530
X-Google-Sender-Auth: kGJz1H10EHFaz4iCFB6AMio2TVA
Message-ID: <AANLkTimA8ZP4WL8u0Uvtt-0MWXPkGfjwQ7437pL-h0D-@mail.gmail.com>
Subject: Re: [PATCH] GIC: Assign correct flow handler type in set_type callback
From: Rabin Vincent <rabin@rab.in>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, Chao Xie <chao.xie@marvell.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 10:59 AM, Abhijeet Dharmapurikar
<adharmap@codeaurora.org> wrote:
> There are some interrupts that are true edge triggered in nature. If not
> marked IRQ_PENDING, when disabled, they will be lost.
>
> Use the set_type callback to assign the correct flow type handler for
> shared peripheral interrupts.
>
> Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> ---
> This came to light when a edge triggered interrupt was supposed to wakeup the
> sytem. The flow handler was set to the default handle_level_irq. On the resume
> path the flow handler was invoked right after the I bit was cleared but before
> each individual interrupts were enabled. This made the handle_level_irq ignore

Why does the flow handler hit when the interrupt is disabled?  Have you set
IRQF_NOSUSPEND on this interrupt?

> the interrupt (mask_ack it) and it was lost. handle_edge_irq does the right
> thing by marking the interrupt as IRQ_PENDING and when the resume code gets to
> enabling each interrupt this interrupt is resent again.
