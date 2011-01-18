Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1ARFYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 00:24:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34127
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876Ab1ARFYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 00:24:12 -0500
Date: Mon, 17 Jan 2011 21:24:44 -0800 (PST)
Message-Id: <20110117.212444.193701604.davem@davemloft.net>
To: brl+ccmadness@pcpool00.mathematik.uni-freiburg.de
Cc: richm@oldelvet.org.uk, 609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        Jesper.Nilsson@axis.com, jeffm@suse.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110117143954.GA17813@pcpool00.mathematik.uni-freiburg.de>
References: <20110115.211722.39173519.davem@davemloft.net>
	<20110116.220755.179947617.davem@davemloft.net>
	<20110117143954.GA17813@pcpool00.mathematik.uni-freiburg.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Bernhard R. Link" <brl+ccmadness@pcpool00.mathematik.uni-freiburg.de>
Date: Mon, 17 Jan 2011 15:39:54 +0100

> * David Miller <davem@davemloft.net> [110117 07:07]:
>> Ugh, and I just noticed that include/linux/klist.h does this fixed
>> alignment of "4" too, where is this stuff coming from?  It's
>> wrong on 64-bit, at best.  But I can't see the impetus behind doing
>> this at all in the first place.
> 
> Is that actually misaligned? Unless I still mix things up, that is in the
> struct thus should be fine (i.e. the "d" case in my example above).

On CRIS, structs naturally align on a byte-boundary only.

However, code using klists encodes a binary state in the lowest bit of
klist pointers.  So this assumes that the structures will be at least
2 byte aligned, which will not be true on CRIS.

We have a lot of other code which uses this trick (encoding 1 or 2
bits of binary state into the lowest bits of a pointer) so I'm
surprised this workaround isn't needed elsewhere for CRIS too.
