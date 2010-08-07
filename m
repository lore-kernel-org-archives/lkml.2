Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762648Ab0HGNP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 09:15:59 -0400
Received: from web37608.mail.mud.yahoo.com ([209.191.87.91]:29947 "HELO
	web37608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762638Ab0HGNP5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 09:15:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ZFvMgbXmUyGhxMmsBSqwOMiIUMmNTzYxYBx8NYRXljuKqEOlJz+FPGiDAvjNNcVfor3BXiIwBJbdqLxBJi4FucaKUtFCZGFTCO50tSx30MT6EmRVrTdV7QxRUlVoiBUu8ijeok17+9h6jgwOnIPqIJhI/2hHZK9HYI+hBfVskoA=;
Message-ID: <494015.19325.qm@web37608.mail.mud.yahoo.com>
X-YMail-OSG: jHZOzyUVM1nIZzlwiWt2aFp52CvANuEk.ont_b4iGSBsNA1
 6eRzpDakk5pd7RanAZw5b4PK1acQ2Efdz4A71q8_2rAG6clw39bDWQW2rQQZ
 bPB6qOhofeGVx0Xm4ZlAEdZj2CmQepDdGJXRGRT_jJo.EZr4a85UmuFHxqdt
 9SspRKHvImnyohy27CBDmAfWU.e1mKN4r1npWDbCt1e_.wBcjStKaN4lEmqd
 d5rSS1EpwIpRRmot1CIuPzmyXTAqX6593Dm.H2d86jOeJIRsDuTdxhmi69HZ
 MBYcw2_O2ob7bSkZJeT6K5qZqKHq6xM897EnKx6d1
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sat, 7 Aug 2010 06:15:55 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281092199.5213.3.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > > > 
> > > > > > > That's how its called in the
> spec.
> > > > > > > Sectors can be larger than
> 512b on
> > > Pro-HG sticks, and
> > > > > > there's additional
> > > > > > > TPC_READ/WRITE_QUAD_DATA
> which operates
> > > on larger
> > > > > > quantities.
> > > > > > But not on ordinary PRO, right?
> > > > > 
> > > > > Pro sectors are normally 512 bytes.
> > > > > 
> > > > > > 
> > > > > > Small question, can I use Pro-HG
> stick in my
> > > reader that is
> > > > > > designed for
> > > > > > Standard/PRO only? Does your
> subsystem
> > > support it?
> > > > > 
> > > > > It should work. It works for me on TI,
> which has
> > > no 8b mode either.
> > > > In that case, is there an upper limit on
> sector size?
> > > Also, you don't use the MS_TPC_READ_QUAD_DATA at
> all.
> > > So mspro_blk.c won't work with >512
> bytes/sector disk?
> > > Or there is some compatibility?
> > > 
> > 
> > The code can work with arbitrarily sized pages, 512b
> > value is not hard coded. All that is needed is to
> slightly alter 
> > h_mspro_block_transfer_data function, given, of
> course, that adapters
> > support longer transfer 
> 
> No, I mean if I go and buy memstick PRO HG, that has >
> 512 bytes/sector,
> will it work with current code?
> 
> Btw, there is currently no way of telling core about
> maximum transfer
> length.
> Here absolute maximum is 1024 (number of bit that _might_
> hold TPC
> length), and FIFO size is 512 bytes (maybe its possible to
> use fifo
> twice)
> 

On TI adapters, FIFO can be reused and DMA restarted. Jmicron adapters are
funny beasts, but their team is keen to support MSpro-HG, so at some
point it will be fully possible, though, probably, not with every version
of the chipset.




      
