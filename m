Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab0FPI64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:58:56 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:38478 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754631Ab0FPI6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:58:54 -0400
Message-ID: <000801cb0d32$24ca1360$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew" <andrew.chih.howe.khor@intel.com>,
       "Intel OTC" <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
References: <001401cb0c58$33b3ae20$66f8800a@maildom.okisemi.com> <201006151237.30698.arnd@arndb.de>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Date: Wed, 16 Jun 2010 17:58:48 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

For user useful, I have decided to implement 'pos' processing to Phub driver.

I have a question.
> Especially if you want to be able to use tools like 'cat', 'hexdump'
> or 'dd' on the file descriptor, you need to implement support for
> short reads.
I don't know how to test(short read/write access).
Could you tell me how to do the above ?

Thanks,
Ohtake.

----- Original Message ----- 
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>; "Wang, Qi" <qi.wang@intel.com>; "Intel OTC" <joel.clark@intel.com>; "Andrew"
<andrew.chih.howe.khor@intel.com>; "LKML" <linux-kernel@vger.kernel.org>; "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Sent: Tuesday, June 15, 2010 7:37 PM
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver


> On Tuesday 15 June 2010, Masayuki Ohtake wrote:
> > I have additional question.
> > > - When the user does an llseek or pread, the *pos argument is not zero,
> > >   so you should return data from the middle, but you still return data
> > >   from the beginning.
> >
> >
> > Must a driver read/write method support '*pos' parameter ?
> > We think PHUB doesn't have to support '*pos',
> > and ,we think, PHUB OROM R/W function supports only whole of ROM data R/W is enough.
> > Please give us your opinion.
>
> While you do not strictly need to support *pos to get the functionality
> you want, it should be easy enough to implement and it will make the
> read/write callbacks conform to the general semantics of file based
> I/O. Especially if you want to be able to use tools like 'cat', 'hexdump'
> or 'dd' on the file descriptor, you need to implement support for
> short reads. If you are unsure about how to do that correctly, I can
> help you some more. A good reference implementation is
> simple_transaction_read in fs/libfs.c, which simply returns some
> private memory.
>
> If there is a strict hardware limitation that prevents you from doing
> partial writes, you could expose that in the interface and return -EIO
> in case of invalid *pos or size arguements, but my impression was that
> the hardware can deal with bytewise access.
>
> Arnd
>


