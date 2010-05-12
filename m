Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab0ELLxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 07:53:47 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60057 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755572Ab0ELLxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 07:53:45 -0400
Date: Wed, 12 May 2010 13:53:40 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       saeed bishara <saeed.bishara@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       DE/ATA development list <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [BUG] bug when enabling VM DEBUG
Message-ID: <20100512115340.GA11261@Chamillionaire.breakpoint.cc>
References: <AANLkTikkSRI6u_mp6mNQReECB84t3oh-_MPVzAYEQULN@mail.gmail.com>
 <AANLkTikoNc6oAY5JthYX1jWx1w2KeJ1fGab72Z-OvIVG@mail.gmail.com>
 <4BEA1559.9000107@gmail.com>
 <1273662639.23818.67.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1273662639.23818.67.camel@e102109-lin.cambridge.arm.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Catalin Marinas | 2010-05-12 12:10:39 [+0100]:

>> > --- a/drivers/ata/libata-sff.c
>> > +++ b/drivers/ata/libata-sff.c
>> > @@ -894,7 +894,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
>> >                                         do_write);
>> >          }
>> >
>> > -       if (!do_write)
>> > +       if (!do_write&&  !PageSlab(page))
>> >                  flush_dcache_page(page);
>> 
>> I would think that check belongs inside flush_dcache_page itself, rather
>> than forcing every driver to include it..
>
>Sebastian (cc'ed) reported this as well for MIPS.
Thx. The patch above looks what I've sent a while ago. Jeff was going to
merge it afaik.

>I think it makes sense for this check to be done in the
>flush_dcache_page() function.

Why should flush_dcache_page() not flush pages you tell it?
>From Documentation/cachetlb.txt:
|   NOTE: This routine need only be called for page cache pages
|          which can potentially ever be mapped into the address
|          space of a user process.  So for example, VFS layer code
|          handling vfs symlinks in the page cache need not call
|          this interface at all.

A page from slab or stack is not going to see the sky of user land and
therefore it should not be fed into flush_dcache_page().

Sebastian
