Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab0I0RgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:36:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41728 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759781Ab0I0RgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=f/jrezqB9uAAru86wESTXGLYHWhHk4Nk2dXn5B0dDKJXnBi7mSdrNrit/tkRfG/qao
         cSF6ZDPY76B4tgIna94BfssdSpoOXMNzepUdcLQxdjQCauuaQsKdKdCOCBtwu4+3xYE3
         AfDpqESojCTmX5b+AwAXbrZ00eVfc/UoiDLbo=
MIME-Version: 1.0
In-Reply-To: <20100908152036.643594727@linutronix.de>
References: <20100908152036.643594727@linutronix.de>
Date: Mon, 27 Sep 2010 10:36:16 -0700
X-Google-Sender-Auth: ooRWHqA_T8INAToUscrqMNiXxQA
Message-ID: <AANLkTikVHO9DmyTX==CwViDK1rP0masBwjMakHZ0U=kZ@mail.gmail.com>
Subject: Re: [RFC trollpatch 1/1] genirq: Remove the fits all and nothing
 __do_IRQ() code
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, linux-alpha@vger.kernel.org,
        linux-cris-kernel@axis.com, Haavard Skinnemoen <hskinnemoen@atmel.com>,
        linux-ia64@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Greg Ungerer <gerg@uclinux.org>, Jeff Dike <jdike@addtoit.com>,
        linux-parisc@vger.kernel.org, Chris Zankel <chris@zankel.net>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 11:14 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>  The following architectures are still using __do_IRQ():
>
>  alpha, cris, ia64, h8300, m32r, m68knommu, parisc, um

Thomas,

I (belatedly) took a look at fixing ia64 ... but I've run into a small snag.
The __do_IRQ() routine makes a call to:

 desc->chip->end(irq);

while neither of the "handle_level_irq()" nor "handle_edge_irq()"
functions do this.

On ia64 iosapic_end_level_irq() call iosapic_eoi() for me. Without it
my system hangs during boot (with some driver timeout complaining
about dropped interrupts).

Is the omission of desc->chip->end(irq); deliberate? In which case
I need to find another place to call iosapic_eoi(). Or is it accidental?

Thanks

-Tony
