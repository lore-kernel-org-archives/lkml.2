Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1E3Cse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 22:48:34 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53040 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752085Ab1E3Csd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 22:48:33 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18VD5Qs9ZEVH4VqOcLZ3wWj+adYUafhbmuq/ZC103
	h7squ7t9IKY1Hh
Subject: Re: recursive fault in 2.6.35.5
From: Mike Galbraith <efault@gmx.de>
To: Whit Blauvelt <whit@transpect.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110529162738.GA7832@black.transpect.com>
References: <20110529162738.GA7832@black.transpect.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 04:48:29 +0200
Message-ID: <1306723709.4895.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-29 at 12:27 -0400, Whit Blauvelt wrote:
> Hi,
> 
> This isn't a most-recent kernel, so we should upgrade the systems with it,
> but it could also be useful to know why the fault occurred. If someone here
> can easily decode the final messages when the system froze....
> 
> This is vanilla 2.6.35.5, built from source, running with Ubuntu Server
> 10.04.2. Two similar systems have been running stably for months, then
> yesterday and today both froze up - one twice. On the one where I was able
> to get a remote console before rebooting the final messages are in a screen
> capture at
> 
> http://www.transpect.com/jpg/sb2crash.jpg
> 
> The final lines are
> 
> [3521437.065988] RIP  [<ffffffff81054ddc>] set_next_entity+0xc/0xa0
> [3521437.065993]  RSP <ffff8801b60b1748>
> [3521437.065994] CR2: 0000000000000038
> [3521437.065997] ---[ end trace 5a40c5f226029029 ]---
> [3521437.065999] Fixing recursive fault but reboot is needed!
> 
> These are basically file servers running NFS, samba, and some Python. I know
> there are recent improvements to the kernel's NFS functions. Does this point
> in that direction as the cause of the recursive fault?

No, you've been bitten by an annoyingly elusive load balancing bug.

	-Mike

