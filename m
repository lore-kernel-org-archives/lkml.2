Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425Ab0FKNr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 09:47:29 -0400
Received: from mail001.aei.ca ([206.123.6.130]:35753 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756384Ab0FKNr2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 09:47:28 -0400
From: Ed Tomlinson <edt@aei.ca>
To: =?utf-8?q?L=C3=A1szl=C3=B3_Monda?= <laci@monda.hu>
Subject: Re: Hardcore trashing without any swap
Date: Fri, 11 Jun 2010 09:47:23 -0400
User-Agent: KMail/1.13.3 (Linux/2.6.34-crc; KDE/4.4.4; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <AANLkTil0M_2aiRX5IoMzC90O9WgzJPco3arHmDSG_44H@mail.gmail.com> <20100611131652.053afebd@lxorguk.ukuu.org.uk> <AANLkTilPJYVbAJEEUMInaB9R4fUPPvq_pS3PdROpifIp@mail.gmail.com>
In-Reply-To: <AANLkTilPJYVbAJEEUMInaB9R4fUPPvq_pS3PdROpifIp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006110947.24286.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 June 2010 08:53:50 László Monda wrote:
> On Fri, Jun 11, 2010 at 2:16 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > On Fri, 11 Jun 2010 02:10:33 +0200
> > László Monda <laci@monda.hu> wrote:
> >
> >> Hi List,
> >>
> >> The problem I'm facing with is very simple, yet extremely irritating
> >> in nature.  I have a laptop with 4G RAM and I don't use any swap.
> >> Whenever the RAM is full my system keeps trashing.  This makes X and
> >> SSH completely unresponsive for about a hour then a bunch of processes
> >> gets killed and it's usable again.
> >>
> >> How is possible that my system is trashing even though I don't use any swap?
> >
> > Because you don't have any swap. Its having to dump stuff it doesn't want
> > to like bits of applications that it can retrieve back from disk.
> 
> I can read what you wrote but cannot really understand it.  Please
> tell me where my logic fails:
> 
> No swap -> no dedicated space on disk to dump stuff -> no disk I/O
> should happen at all

No.  This is not the case.  If the vm needs memory it will discard pages from that are
backed by objects _not_ stored in swap - like executables.  Only if there is nothing to
discard will it start killing...  That being said you need to read up on what Alan's 
suggestion below does - or add a swapfile (which works nearly as well as a swap partition 
now).

> >> I'd expect the kernel to immediately kill the largest process without
> >> any trashing so I could continue my work right after the event.  How
> >> is it possible to configure?

See above.  Its not out of memory that it can discard without killing... 

> > It isn't.
> >
> > However if you want to avoid overcommit and thrashing play with
> >
> > /proc/sys/vm/overcommit*

Ed
