Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab2DZH04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 03:26:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57387 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab2DZH0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 03:26:55 -0400
Date: Thu, 26 Apr 2012 03:25:28 -0400 (EDT)
Message-Id: <20120426.032528.2066041048224573812.davem@davemloft.net>
To: schwidefsky@de.ibm.com
Cc: viro@ZenIV.linux.org.uk, oleg@redhat.com, torvalds@linux-foundation.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tj@kernel.org, arnd@arndb.de,
        roland@hack.frob.com
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120426091519.49eef9aa@de.ibm.com>
References: <20120425170230.GA24977@redhat.com>
	<20120425175113.GI6871@ZenIV.linux.org.uk>
	<20120426091519.49eef9aa@de.ibm.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 Apr 2012 00:25:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Thu, 26 Apr 2012 09:15:19 +0200

> You need to be careful with inferior calls there. gdb likes to play games
> with the registers inside the get_signal_to_deliver call, it wants to be
> able to jump out of an interrupted system call, do its inferior call in
> the debugee and then return to the interrupted system call.
> You would have to to read, modify & restore the NEED_RESTART flag in gdb
> over an inferior call.

Right and this is what orig_ax and friends are used for on x86.
