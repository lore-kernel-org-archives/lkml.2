Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab0JIQHG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 12:07:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34144 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab0JIQHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 12:07:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LLRdqrqjjnp/x7KaKM10HGZBLe4+NTgsn6OKvpiIafkOh2Uc/zm/bymgkc1aYUNa+K
         ElQhZQDCb5KnsP4ZhLF7lZu+wmEUXIqLQCSZxQt/L1rbjxB1z9r7Om7ES6yFDiW1J49q
         XOeuVc6ahJ/FpixvWmok4xQtioIJ6j0g+WTD0=
MIME-Version: 1.0
In-Reply-To: <20101009135210.GA25564@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101009135210.GA25564@n2100.arm.linux.org.uk>
Date: Sat, 9 Oct 2010 19:07:01 +0300
Message-ID: <AANLkTi=Sv35ipSGzSoJMjdoNU-Qee9csviPL3yMSM3uf@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 9, 2010 at 4:52 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Oct 07, 2010 at 12:44:22PM +0300, Felipe Contreras wrote:
>> For issues related to this:
>> http://article.gmane.org/gmane.linux.ports.arm.kernel/84454
>
> This one nicely shows some of the problems which can occur with the
> memory type attributes - and this is not attributable to ioremap().
>
> ioremap() is used to map devices.  It creates device memory type mappings.
> If what you're mapping doesn't support device memory type mappings, then
> accesses via an ioremap()'d region isn't going to work - as this guy is
> observing.
>
> That's not because ioremap() is doing something wrong.  It's doing what
> it's meant to do.  The use is wrong, and is completely unrelated to the
> issue you've raised.

Ok, I was confused by Catalin's comment which does point to ioremap()
on normal RAM:
http://article.gmane.org/gmane.linux.ports.arm.kernel/84504

>> http://article.gmane.org/gmane.linux.ports.sh.devel/8560
>
> This one we know about, and as I've already said, it ends up with three
> aliasing mappings each with different attributes thusly:
>
>        cpu = dma_alloc_coherent(dev, size, &dma, GFP_KERNEL);
>        dma_declare_coherent_memory(dev, dma, dma, size, DMA_MEMORY_MAP);
>                ==> ioremap(dma, size);
>        ...
>        dma_alloc_coherent(dev, ...);
>
> This wasn't spotted in the review of sh-mobile code because it's not part
> of the sh-mobile code base, but some of the generic sh architecture code.
> sh-mobile went into the kernel on March 12th, so it does pre-date the
> change to ioremap, and is therefore technically a regression.
>
> However, as can be seen from the link above, it's been known about since
> 8th August - two months ago.  The problem has been discussed, and we had
> a good solution which would work.  But then an oar got thrown in which
> basically resulted in that solution being rejected - on the basis that
> "it's an established API and it must work".

I don't see anyone rejecting any solution there. Where is anybody
saying "it's an established API and it must work"?

> Well, this usage of the API doesn't work on x86!
>
> The result - progress on the issue hit a brick wall and is unable to
> proceed because of personal viewpoints conflicting with reality.

Can you concentrate on the patch at hand?
http://article.gmane.org/gmane.linux.kernel/1045670

This doesn't break anything, nor prevents anyone coming up with solutions.

>> http://www.spinics.net/lists/linux-fbdev/msg01745.html
>
> External user?  Unreviewed code?  You can't seriously be suggesting
> that we should care about code we haven't seen which is sitting
> externally to the kernel tree, and this is a valid reason to hold
> off on changes to the kernel.

It's a plus, not the main reason to apply this patch. However,
progress is not held by any means, people can still fix their drivers,
generic solutions can still be proposed and worked on... This patch
doesn't hurt anybody.

You haven't answered my question: what is so horrible about warning
only on .36, and disallowing on .37?

-- 
Felipe Contreras
