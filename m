Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2ITUqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 16:46:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39268 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab2ITUqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 16:46:00 -0400
Date: Thu, 20 Sep 2012 16:45:58 -0400 (EDT)
Message-Id: <20120920.164558.2281417114805373564.davem@davemloft.net>
To: mika.westerberg@linux.intel.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120920091013.GV15548@intel.com>
References: <20120920173622.2aa7209cd241a3945f4384d4@canb.auug.org.au>
	<20120920091013.GV15548@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Thu, 20 Sep 2012 12:10:14 +0300

> On Thu, Sep 20, 2012 at 05:36:22PM +1000, Stephen Rothwell wrote:
>> Hi all,
>> 
>> After merging the final tree, today's linux-next build (powerpc
>> allyesconfig) failed like this:
>> 
>> drivers/net/ethernet/i825xx/znet.c: In function 'hardware_init':
>> drivers/net/ethernet/i825xx/znet.c:868:2: error: implicit declaration of function 'isa_virt_to_bus' [-Werror=implicit-function-declaration]
>> 
>> Caused by commit 1d3ff76759b7 ("i825xx: znet: fix compiler warnings when
>> building a 64-bit kernel").  Is there some Kconfig dependency missing (CONFIG_ISA)?
> 
> If we make it dependent on CONFIG_ISA then the driver cannot be built with
> 64-bit kernel. Then again is there someone running 64-bit kernel on Zenith
> Z-note notebook? From the pictures it looks like very ancient "laptop".
> 
> An alternative is to make it depend on X86 like this:

I think the powerpc port is at fault here.

Part of being able to advertise ISA_DMA_API is providing isa_virt_to_bus().
