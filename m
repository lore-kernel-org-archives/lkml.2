Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab0HHNbO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 09:31:14 -0400
Received: from web37606.mail.mud.yahoo.com ([209.191.87.89]:28965 "HELO
	web37606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753700Ab0HHNbM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 09:31:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=giuGWsEoBSgOAC+NegE8cTaZRbF2vfUFoxjAik2tlrsfunoZRzoBua4LLgzOoOAWFtyO4+PddfrLbs+G/pqIbgjdv6imvQSeX8c+GjMeqpNSCdpVoEYDItvZPifa2AaLOKSCWIIVViIUC8GTpCV+PUsJ18yJffyIwjEnExONJ6Q=;
Message-ID: <639782.98203.qm@web37606.mail.mud.yahoo.com>
X-YMail-OSG: 4YRu_OkVM1nDAcbC9L_yOkgfDPnpKCLuqvD_lTMcW2PfMuh
 rDXrOd3B13HlwMMck9XEQURLe_Ea3d4shyUGQk1Ur0PZ.dwoVGJXOapW7oAk
 FX5Bau._7kyxwMscjszNv0b54H_KAeK0ojw0BCNbLy5pxO8tzewTS6nGAs_e
 hL8p0qe9Xs7dTNNj8eW57EVAUiUtkTRhB_QFkZrhLzoJJlvM525t5Dtvyoms
 GECFY_55ptXcgemKMXu6mfdm4_lRlJQC.1mEXS9EKlgf_7foSRCjwfuCzzKl
 WaSeIklYdiP7_Tbu95tVInO.9YfF3TjmLZfFlITyCs3UqzJc-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sun, 8 Aug 2010 06:31:10 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281196738.3300.2.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sat, 7/8/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "LKML" <linux-kernel@vger.kernel.org>
> Received: Saturday, 7 August, 2010, 8:58 AM
> On Sat, 2010-08-07 at 06:15 -0700,
> Alex Dubov wrote: 
> > > > > > > > > 
> > > > > > > > > That's how its
> called in the
> > > spec.
> > > > > > > > > Sectors can be
> larger than
> > > 512b on
> > > > > Pro-HG sticks, and
> > > > > > > > there's additional
> > > > > > > > >
> TPC_READ/WRITE_QUAD_DATA
> > > which operates
> > > > > on larger
> > > > > > > > quantities.
> > > > > > > > But not on ordinary PRO,
> right?
> > > > > > > 
> > > > > > > Pro sectors are normally 512
> bytes.
> > > > > > > 
> > > > > > > > 
> > > > > > > > Small question, can I
> use Pro-HG
> > > stick in my
> > > > > reader that is
> > > > > > > > designed for
> > > > > > > > Standard/PRO only? Does
> your
> > > subsystem
> > > > > support it?
> > > > > > > 
> > > > > > > It should work. It works for
> me on TI,
> > > which has
> > > > > no 8b mode either.
> > > > > > In that case, is there an upper
> limit on
> > > sector size?
> > > > > Also, you don't use the
> MS_TPC_READ_QUAD_DATA at
> > > all.
> > > > > So mspro_blk.c won't work with >512
> > > bytes/sector disk?
> > > > > Or there is some compatibility?
> > > > > 
> > > > 
> > > > The code can work with arbitrarily sized
> pages, 512b
> > > > value is not hard coded. All that is needed
> is to
> > > slightly alter 
> > > > h_mspro_block_transfer_data function, given,
> of
> > > course, that adapters
> > > > support longer transfer 
> > > 
> > > No, I mean if I go and buy memstick PRO HG, that
> has >
> > > 512 bytes/sector,
> > > will it work with current code?
> > > 
> > > Btw, there is currently no way of telling core
> about
> > > maximum transfer
> > > length.
> > > Here absolute maximum is 1024 (number of bit that
> _might_
> > > hold TPC
> > > length), and FIFO size is 512 bytes (maybe its
> possible to
> > > use fifo
> > > twice)
> > > 
> > 
> > On TI adapters, FIFO can be reused and DMA restarted.
> Jmicron adapters are
> > funny beasts, but their team is keen to support
> MSpro-HG, so at some
> > point it will be fully possible, though, probably, not
> with every version
> > of the chipset.
> > 
> 
> I still need an answer for whether HG sticks need
> MS_TPC_READ_QUAD_DATA
> to be used.

No, they work fine with LONG_DATA, at least the ones I tried.

> 
> But anyway, I buy a HG stick and see how it works.

This is always a right thing to do.

> 
> Best regards,
> Maxim Levitsky
> 
> 


      
