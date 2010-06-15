Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab0FOKhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 06:37:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62901 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab0FOKhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 06:37:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Date: Tue, 15 Jun 2010 12:37:30 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Intel OTC" <joel.clark@intel.com>,
       "Andrew" <andrew.chih.howe.khor@intel.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
References: <001401cb0c58$33b3ae20$66f8800a@maildom.okisemi.com>
In-Reply-To: <001401cb0c58$33b3ae20$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006151237.30698.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+YIpxgeuhNyggsluiM64lcJdNwTWVRIcg8bQT
 6XIRpW97wCpCrqTapFZjHI/9DQkau0pq+VvhbVy8xzf7ULRsVy
 jRkrhlQ/hye/OhKqsOkxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 June 2010, Masayuki Ohtake wrote:
> I have additional question.
> > - When the user does an llseek or pread, the *pos argument is not zero,
> >   so you should return data from the middle, but you still return data
> >   from the beginning.
> 
> 
> Must a driver read/write method support '*pos' parameter ?
> We think PHUB doesn't have to support '*pos',
> and ,we think, PHUB OROM R/W function supports only whole of ROM data R/W is enough.
> Please give us your opinion.

While you do not strictly need to support *pos to get the functionality
you want, it should be easy enough to implement and it will make the
read/write callbacks conform to the general semantics of file based
I/O. Especially if you want to be able to use tools like 'cat', 'hexdump'
or 'dd' on the file descriptor, you need to implement support for
short reads. If you are unsure about how to do that correctly, I can
help you some more. A good reference implementation is
simple_transaction_read in fs/libfs.c, which simply returns some
private memory.

If there is a strict hardware limitation that prevents you from doing
partial writes, you could expose that in the interface and return -EIO
in case of invalid *pos or size arguements, but my impression was that
the hardware can deal with bytewise access.

	Arnd
