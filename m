Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab2EFXiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 19:38:21 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43232 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab2EFXiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 19:38:20 -0400
Date: Sun, 06 May 2012 19:38:14 -0400 (EDT)
Message-Id: <20120506.193814.2029338625165610372.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: hpa@zytor.com, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120506233234.GA22082@ZenIV.linux.org.uk>
References: <b73ca203-c9d8-4ca3-b680-d00499f284cd@email.android.com>
	<20120506.163243.1653904376439925642.davem@davemloft.net>
	<20120506233234.GA22082@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 06 May 2012 16:38:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Mon, 7 May 2012 00:32:34 +0100

> bit looks dubious.  What happens when 32bit task makes a 64bit syscall?
> Do we really want to drop upper 32 bits of all arguments in the copy we
> are building?

I basically never intended to support 32-bit tasks making 64-bit
system calls except in extremely limited situations such as ptrace()
so that a 32-bit gdb could debug 64-bit tasks.

Do we really have to support crap like this?
