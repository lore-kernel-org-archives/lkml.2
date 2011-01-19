Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1ASWVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:21:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54533
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754459Ab1ASWVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:21:03 -0500
Date: Wed, 19 Jan 2011 14:21:37 -0800 (PST)
Message-Id: <20110119.142137.184823805.davem@davemloft.net>
To: mathieu.desnoyers@efficios.com
Cc: rostedt@goodmis.org, richm@oldelvet.org.uk, 609371@bugs.debian.org,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110119221327.GA23544@Krystal>
References: <20110119153326.GC11022@Krystal>
	<20110119.134047.232915743.davem@davemloft.net>
	<20110119221327.GA23544@Krystal>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Wed, 19 Jan 2011 17:13:27 -0500

> Hrm, I'd like to see what kind of ill-conceived 32-bit architecture would
> generate a unaligned access for a 32-bit aligned u64. Do you have examples in
> mind ? By definition, the memory accesses should be at most 32-bit, no ? AFAIK,
> gcc treats u64 as two distinct reads on all 32-bit architectures.

Sparc 32-bit has 64-bit loads and stores, GCC uses them because the ABI
specifies that every structure is at least 8 byte aligned.

> gcc on my sparc64 box (32-bit userland) disagrees with you here ;) Using
> gcc (Debian 4.3.3-14) 4.3.3, here is a demonstration that, indeed, "packed"
> generates aweful code, but that "packed, aligned(4 or 8)" generates pretty
> decent code:

Amazing, if this works then do it.

But please document this fully with comments and such :-)
