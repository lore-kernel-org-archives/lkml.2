Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab1ARGtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 01:49:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44411
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812Ab1ARGts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 01:49:48 -0500
Date: Mon, 17 Jan 2011 22:50:22 -0800 (PST)
Message-Id: <20110117.225022.59651505.davem@davemloft.net>
To: richm@oldelvet.org.uk
Cc: 609371@bugs.debian.org, ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, Jesper.Nilsson@axis.com, jeffm@suse.com
Subject: Re: R_SPARC_13
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110117.163709.15244083.davem@davemloft.net>
References: <20110117.130238.245404805.davem@davemloft.net>
	<1295307243.32152.106.camel@duncow>
	<20110117.163709.15244083.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 17 Jan 2011 16:37:09 -0800 (PST)

> So we do end up seeing the R_SPARC_LO10 + R_SPARC_13 sequences in the
> final module object.
> 
> Therefore, we really should handle R_SPARC_13 in the sparc module loader.

Ok, I now feel like I'm hallucinating.

davem@sunset:~/src/GIT/linux-2.6-stable$ uname -a
Linux sunset 2.6.37 #1 SMP Wed Jan 12 20:14:59 PST 2011 sparc64 GNU/Linux
davem@sunset:~/src/GIT/linux-2.6-stable$ objdump --reloc /lib/modules/2.6.37/kernel/net/ipv6/ipv6.ko | grep R_SPARC_13
0000000000000c7c R_SPARC_13        *ABS*+0x0000000000000004
0000000000001ae4 R_SPARC_13        *ABS*+0x0000000000000018
0000000000001b0c R_SPARC_13        *ABS*+0x0000000000000008
 ...
davem@sunset:~/src/GIT/linux-2.6-stable$ lsmod | grep ipv6
ipv6                  240422  12 
davem@sunset:~/src/GIT/linux-2.6-stable$ 

I must be missing something obvious.

