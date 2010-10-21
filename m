Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab0JUQJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 12:09:44 -0400
Received: from www.tglx.de ([62.245.132.106]:33764 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955Ab0JUQJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 12:09:42 -0400
Date: Thu, 21 Oct 2010 18:09:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Weinberger <richard@nod.at>
cc: peterz@infradead.org, hpa@zytor.com, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: linux-next: User Mode Linux broken
In-Reply-To: <201010211315.26679.richard@nod.at>
Message-ID: <alpine.LFD.2.00.1010211805040.2418@localhost6.localdomain6>
References: <201010211315.26679.richard@nod.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010, Richard Weinberger wrote:

> Thomas,
> 
> Your commit c5f7563 ("genirq: Provide compat handling for chip->enable()") 
> breaks UML.
> It does not start anymore.
> 
> When I apply this patch it works fine again.
> http://userweb.kernel.org/~akpm/mmotm/broken-out/um-migrate-from-__do_irq-to-
> generic_handle_irq.patch
> 
> Maybe your patch breaks all users of __do_IRQ()?

Not intentionally :)

The irq_chip of um has it's own dummy enable function, so the compat
code uses it.

+static void compat_irq_enable(struct irq_data *data)
+{
+	data->chip->enable(data->irq);
+}
+

...

+	if (chip->enable)
+		chip->irq_enable = compat_irq_enable;
+
+	/*
+	 * The real defaults
+	 */
+	if (!chip->irq_enable)
+		chip->irq_enable = default_enable;

So I really can't see how's that supposed to break UM

Thanks,

	tglx
