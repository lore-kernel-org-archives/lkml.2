Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0IHU3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 16:29:05 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43196 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab0IHU25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 16:28:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=o60oP9lMZXXmMxxY+21O8WQg8rMbBhUbOYCMIBNn9RI2EnJ6YGEf2n95ltuhkzI8z3
         xpAmbtzKZnFzCBrpDyCHfkjw6XMwtpiJQsLvuTe2ypKA/RBLUge8Ygxx9cktQfrGnZXo
         yIrRFT6mTueCoQToyzLCcKx+xKu5pyJjq58zk=
MIME-Version: 1.0
In-Reply-To: <1283971919.11763.35.camel@mulgrave.site>
References: <20100908152036.643594727@linutronix.de> <1283971919.11763.35.camel@mulgrave.site>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 8 Sep 2010 16:28:07 -0400
Message-ID: <AANLkTimC1kBuAvd_kei8cdWvgzL-u8FdfEfEGZH1t2ZM@mail.gmail.com>
Subject: Re: [RFC trollpatch 1/1] genirq: Remove the fits all and nothing
 __do_IRQ() code
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, linux-alpha@vger.kernel.org,
        linux-cris-kernel@axis.com, Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Greg Ungerer <gerg@uclinux.org>, Jeff Dike <jdike@addtoit.com>,
        linux-parisc@vger.kernel.org, Chris Zankel <chris@zankel.net>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 14:51, James Bottomley wrote:
> On Wed, 2010-09-08 at 18:14 +0000, Thomas Gleixner wrote:
>> plain text document attachment (genirq-troll-patch.patch)
>> __do_IRQ() has been deprecated after a two years migration phase in
>> commit 0e57aa1. Since then another 18 month have gone by.
>>
>> So here's the status three and a half years after the flow based
>> infrastructure was merged:
>>
>>  The following architectures are still using __do_IRQ():
>>
>>   alpha, cris, ia64, h8300, m32r, m68knommu, parisc, um
>>
>> So now the question arises what to do with __do_IRQ().
>>
>> Removing it would be the right thing, but that'll break 8 archs, so
>> it's probably not considered a good idea, though for most of them the
>> conversion should be reasonably trivial.
>>
>> I'm happy to move that code into kernel/irq/cruft.c forever if there
>> is no way to get the remaining users converted in the forseeable
>> future. It looks like they can cope with the annoying build warning
>> nicely.
>
> Well, if you're going to deprecate something that 8 architectures rely
> on, it would be nice to tell people ... or even just linux-arch ... most
> of us do read that.  I've actually never noticed the warning the commit
> activated in any of my parisc compiles for some reason.

the only reason Blackfin was converted quickly is because the code
issues a warning (that has been there for a long time):
# warning __do_IRQ is deprecated. Please convert to proper flow handlers

so i guess you're saying that you disable the "ENABLE_WARN_DEPRECATED"
option ?  or you dont pay attention to warnings when compiling kernels
?
-mike
