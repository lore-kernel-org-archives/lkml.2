Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab1FTUP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:15:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64730 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1FTUP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:15:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] USB: ehci: use packed, aligned(4) instead of removing the packed attribute
Date: Mon, 20 Jun 2011 22:14:00 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Nicolas Pitre <nico@fluxnic.net>, Alan Stern <stern@rowland.harvard.edu>,
        gregkh@suse.de, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Rabin Vincent <rabin@rab.in>,
        Alexander Holler <holler@ahsoftware.de>,
        linux-arm-kernel@lists.infradead.org
References: <Pine.LNX.4.44L0.1106201329390.2113-100000@iolanthe.rowland.org> <alpine.LFD.2.00.1106201449320.2142@xanadu.home> <20110620193213.GL26089@n2100.arm.linux.org.uk>
In-Reply-To: <20110620193213.GL26089@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106202214.00998.arnd@arndb.de>
X-Provags-ID: V02:K0:CKa/+OjvGUJEIYo8Igqqb6SKCsLJXWEUHb1KuYzvJkd
 PjqH8qC6otE50phiucnXbQMC7iM0L7Eqi3/CNAfgDpNSR/bbBW
 I03mlarWNnc2I/U/A85+T+xMDYQM8h6uAzCWYB5gbbjc4jbpfS
 l0Lp+xqXZ7IdrlYc2zUYrIeMhe/GWtgZQpbe85SNYCGPT8hn+B
 nqLMuhHVkdDMLPN9hE5CA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 June 2011 21:32:13 Russell King - ARM Linux wrote:
> > Here the d member is not naturally aligned.  On most architectures, 
> > including ARM with the ABI currently in use, the compiler would insert a 
> > 32-bit padding between c and d.
> 
> And if 'struct foo' represents a structure in device memory, the end
> result is highly unpredicable whether or not you have padding or
> accessors to load 'd' there.  So, you would not have such a structure
> describing a data structure in memory returned by ioremap().

Right.

> Now, the real question is: is there any architecture which is (or may
> be) supported by the Linux kernel which would add padding to:
> 
> struct foo {
>         u8 a;
>         u8 b;
>         u16 c;
>         u32 d;
>         u64 e;
> };

This is the other issue, which we were facing in the scsi drivers.
If an architecture requires padding because some members require
larger than natural alignment here, the 'packed' should be applied
to that member, in order to change the alignment of that member.

	Arnd
