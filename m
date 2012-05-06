Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2EFXkm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 19:40:42 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43248 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab2EFXkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 19:40:41 -0400
Date: Sun, 06 May 2012 19:40:37 -0400 (EDT)
Message-Id: <20120506.194037.1148847080889462521.davem@davemloft.net>
To: hpa@zytor.com
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
From: David Miller <davem@davemloft.net>
In-Reply-To: <af01067e-5a22-44a8-acb1-368e45dbb06c@email.android.com>
References: <b73ca203-c9d8-4ca3-b680-d00499f284cd@email.android.com>
	<20120506.163243.1653904376439925642.davem@davemloft.net>
	<af01067e-5a22-44a8-acb1-368e45dbb06c@email.android.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 06 May 2012 16:40:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 06 May 2012 13:51:30 -0700

> No.  The input layer exports pointers in structures on the
> read/write paths, and bitmasks encoded in ASCII strings which depend
> on sizeof(long).  The stupid... it burns...

So there has to be a hack in every userland application wherein we
teach it no only about this issue, but add special code to teach it
how to make 64-bit system call traps.

FOR EVERY CPU TYPE?

I'd rather wait for a newer less broken input API to be added, rather
than go through the pain of having to support 64-bit system calls in
32-bit apps.

Nobody on sparc has noticed this yet, and I doubt anyone is going to
care meanwhile.
