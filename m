Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817Ab0FPKu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:50:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60530 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758794Ab0FPKu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:50:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Date: Wed, 16 Jun 2010 12:50:44 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew" <andrew.chih.howe.khor@intel.com>,
       "Intel OTC" <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
References: <001401cb0c58$33b3ae20$66f8800a@maildom.okisemi.com> <201006151237.30698.arnd@arndb.de> <000801cb0d32$24ca1360$66f8800a@maildom.okisemi.com>
In-Reply-To: <000801cb0d32$24ca1360$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006161250.45175.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19yPAaQZ3uskriRzGhSO5OjiGirKym79P9uHZy
 EIq8AdmEKIlWygR+L5nmjWUS6iU0CxgGviZYIYLjqjDtjiBwg6
 ns8WltMz+guVZ4ti3kmdw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 June 2010, Masayuki Ohtake wrote:
> > Especially if you want to be able to use tools like 'cat', 'hexdump'
> > or 'dd' on the file descriptor, you need to implement support for
> > short reads.
> I don't know how to test(short read/write access).
> Could you tell me how to do the above ?

The easiest way is using dd, where you can specify the block
size as well as input and output offsets.

e.g.
dd if=/dev/topcliffphub of=testfile bs=7

Should be able to read the contents of the rom completely
without error conditions, copying seven bytes at a time.

dd if=inputfile of=/dev/topcliffphub bs=1 seek=1024 count=16

would write 16 bytes from inputfile into the rom at position 1024.

	Arnd
