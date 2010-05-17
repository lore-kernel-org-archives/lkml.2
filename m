Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab0EQFHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 01:07:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41827
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958Ab0EQFG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 01:06:59 -0400
Date: Sun, 16 May 2010 22:07:07 -0700 (PDT)
Message-Id: <20100516.220707.193713760.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: serue@us.ibm.com, gregkh@suse.de, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com,
       eric.dumazet@gmail.com, bcrl@lhnet.ca, netdev@vger.kernel.org
Subject: Re: [PATCH 7/6] net/sysfs: Fix the bitrot in network device
 kobject namespace support
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1y6fj3yym.fsf_-_@fess.ebiederm.org>
References: <m14oim2kcm.fsf@fess.ebiederm.org>
	<20100505220150.GA11595@us.ibm.com>
	<m1y6fj3yym.fsf_-_@fess.ebiederm.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 16 May 2010 21:59:45 -0700

> 
> I had a couple of stupid bugs in:
> netns: Teach network device kobjects which namespace they are in.
> 
> - I duplicated the Kconfig for the NET_NS
> - The build was broken when sysfs was not compiled in
> 
> The sysfs breakage is because after I moved the operations
> for the sysfs to the kobject layer, to make things cleaner
> I forgot to move the ifdefs.  Opps.
> 
> I'm not quite certain how I got introduced a second NET_NS Kconfig,
> but it was probably a 3 way merge somewhere along the way that
> did not notice that the NET_NS Kconfig option had mvoed and thout
> that was a bug.  It probably slipped in because it used to be the
> sysfs patches were the first patches in my network namespace patches.
> Some things just don't go like you would expect.
> 
> Neither of these bugs actually affect anything in the common case
> but they should be fixed.
> 
> Thanks to Serge for noticing they were present.
> 
> Reported-by: Serge E. Hallyn <serue@us.ibm.com>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: David S. Miller <davem@davemloft.net>
