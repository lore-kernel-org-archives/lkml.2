Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab0D0Qe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:34:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58087
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756317Ab0D0QeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:34:24 -0400
Date: Tue, 27 Apr 2010 09:34:30 -0700 (PDT)
Message-Id: <20100427.093430.258110898.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100427152516.580ee620.sfr@canb.auug.org.au>
References: <20100427152516.580ee620.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 27 Apr 2010 15:25:16 +1000

> After merging the bkl-ioctl tree, today's linux-next build (powerpc
> ppc44x_defconfig) failed like this:
> 
> net/bridge/br_multicast.c: In function 'br_ip6_multicast_alloc_query':
> net/bridge/br_multicast.c:469: error: implicit declaration of function 'csum_ipv6_magic'
> 
> Introduced by commit 08b202b6726459626c73ecfa08fcdc8c3efc76c2 ("bridge
> br_multicast: IPv6 MLD support") from the net tree.
> 
> csum_ipv6_magic is declared in net/ip6_checksum.h ...

Bummer, powerpc is one of the few platforms that doesn't get the header
file implicitly so you always trip over this whereas we never see it in
x86 and sparc64 builds :-)

I'll fix this, thanks!
