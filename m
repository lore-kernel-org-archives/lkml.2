Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab0HGP7H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 11:59:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59353 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab0HGP7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 11:59:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NvBGz008TT7OSxBm13dnoxKQczaCPmU+HddRtPk6jjKoCpovjt9kMHT7rZ6RBBOLRQ
         Knl1lfsmukQwBJOqKAIjnwIgEWPD4sfqdc01wSjW+c6SWytz0apz1i5TGCJ1xZMMwYcU
         GNWCidBltp2gqle9tSQA64B7W9eWOE6ajUUtg=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <494015.19325.qm@web37608.mail.mud.yahoo.com>
References: <494015.19325.qm@web37608.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 18:58:58 +0300
Message-ID: <1281196738.3300.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-07 at 06:15 -0700, Alex Dubov wrote: 
> > > > > > > > 
> > > > > > > > That's how its called in the
> > spec.
> > > > > > > > Sectors can be larger than
> > 512b on
> > > > Pro-HG sticks, and
> > > > > > > there's additional
> > > > > > > > TPC_READ/WRITE_QUAD_DATA
> > which operates
> > > > on larger
> > > > > > > quantities.
> > > > > > > But not on ordinary PRO, right?
> > > > > > 
> > > > > > Pro sectors are normally 512 bytes.
> > > > > > 
> > > > > > > 
> > > > > > > Small question, can I use Pro-HG
> > stick in my
> > > > reader that is
> > > > > > > designed for
> > > > > > > Standard/PRO only? Does your
> > subsystem
> > > > support it?
> > > > > > 
> > > > > > It should work. It works for me on TI,
> > which has
> > > > no 8b mode either.
> > > > > In that case, is there an upper limit on
> > sector size?
> > > > Also, you don't use the MS_TPC_READ_QUAD_DATA at
> > all.
> > > > So mspro_blk.c won't work with >512
> > bytes/sector disk?
> > > > Or there is some compatibility?
> > > > 
> > > 
> > > The code can work with arbitrarily sized pages, 512b
> > > value is not hard coded. All that is needed is to
> > slightly alter 
> > > h_mspro_block_transfer_data function, given, of
> > course, that adapters
> > > support longer transfer 
> > 
> > No, I mean if I go and buy memstick PRO HG, that has >
> > 512 bytes/sector,
> > will it work with current code?
> > 
> > Btw, there is currently no way of telling core about
> > maximum transfer
> > length.
> > Here absolute maximum is 1024 (number of bit that _might_
> > hold TPC
> > length), and FIFO size is 512 bytes (maybe its possible to
> > use fifo
> > twice)
> > 
> 
> On TI adapters, FIFO can be reused and DMA restarted. Jmicron adapters are
> funny beasts, but their team is keen to support MSpro-HG, so at some
> point it will be fully possible, though, probably, not with every version
> of the chipset.
> 

I still need an answer for whether HG sticks need MS_TPC_READ_QUAD_DATA
to be used.

But anyway, I buy a HG stick and see how it works.

Best regards,
Maxim Levitsky

