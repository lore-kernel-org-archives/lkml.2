Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935433Ab0HFHn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:43:58 -0400
Received: from web37607.mail.mud.yahoo.com ([209.191.87.90]:47487 "HELO
	web37607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935425Ab0HFHnz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:43:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=qS861arqIaxjkXKG0+5O7EyIlsmWSS/et8JSO7hHuDvNpi0F7um2VFcSUWpLuZwAN/QJRHE6L3dJZSbn3wD/4NXSjEaw1HV6LQWWSZdTz1650eeHBMNXshcpZJr7qDk2qIxHtH6XIAxh1Kzp3BHpGahT0dHpn61Fmmn3JRln3BM=;
Message-ID: <840953.65325.qm@web37607.mail.mud.yahoo.com>
X-YMail-OSG: Ygd_rlYVM1nT74yG9IWZuGMJXMwP61FX7vXnP0PcJP9v4At
 HiCONXzIArksfDxQZaRPfzQWlgDmsS1mYnNUa2UGRxhwWmcADv0yaVj.PmBq
 0Ffgf1kPvfymu4q.FCam7EuZnKYVJPOZiHll3uEPlG56se7GxR_tMLMk0cxs
 baJaFkvU_Rn.2X3XhA1ReoN8Da4CmjcuAs.yIOpm4UAfi2vwvGpdF.Tiwxi9
 ixWGtr72isN.De4dANpuci6s.NiDl_aGLuS2cJwwGgRkf8uIldWG1aQcjH_6
 DIm8s5sKu_Gj.1wur8XhigvCdK0Q1jhJb45g.kjA-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Fri, 6 Aug 2010 00:43:52 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281030462.23959.18.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > 
> > > > > That's how its called in the spec.
> > > > > Sectors can be larger than 512b on
> Pro-HG sticks, and
> > > > there's additional
> > > > > TPC_READ/WRITE_QUAD_DATA which operates
> on larger
> > > > quantities.
> > > > But not on ordinary PRO, right?
> > > 
> > > Pro sectors are normally 512 bytes.
> > > 
> > > > 
> > > > Small question, can I use Pro-HG stick in my
> reader that is
> > > > designed for
> > > > Standard/PRO only? Does your subsystem
> support it?
> > > 
> > > It should work. It works for me on TI, which has
> no 8b mode either.
> > In that case, is there an upper limit on sector size?
> Also, you don't use the MS_TPC_READ_QUAD_DATA at all.
> So mspro_blk.c won't work with >512 bytes/sector disk?
> Or there is some compatibility?
> 

The code can work with arbitrarily sized pages, 512b
value is not hard coded. All that is needed is to slightly alter 
h_mspro_block_transfer_data function, given, of course, that adapters
support longer transfer sizes.



      
