Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab0FISGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:06:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34477
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994Ab0FISG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:06:29 -0400
Date: Wed, 09 Jun 2010 11:06:38 -0700 (PDT)
Message-Id: <20100609.110638.112605100.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for June 9 (niu)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100609103657.66252a27.randy.dunlap@oracle.com>
References: <20100609133443.38f1f957.sfr@canb.auug.org.au>
	<20100609103657.66252a27.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 9 Jun 2010 10:36:57 -0700

> On Wed, 9 Jun 2010 13:34:43 +1000 Stephen Rothwell wrote:
> 
>> Changes since 20100608:
>> 
>> My fixes tree contains:
>>       v4l-dvb: update gfp/slab.h includes
>>       arm: update gfp/slab.h includes
>>       davinci: update gfp/slab.h includes
>>       ocfs2: update gfp/slab.h includes
>>       acpi: update gfp/slab.h includes
> 
> 
> 
> on x86_64 or i386, CONFIG_OF_DEVICE is not enabled:
> 
> drivers/net/niu.c:9700: warning: 'struct of_device' declared inside parameter list
> drivers/net/niu.c:9700: warning: its scope is only this definition or declaration, which is probably not what you want
> drivers/net/niu.c:9716: warning: assignment from incompatible pointer type

Hmmm, I'm confused why this never happened before :-)

We conditionalize linux/of_device.h inclusion with CONFIG_SPARC64, yet
we unconditionally use "struct of_device *" pointers in the driver
with no such ifdef protection.

Even if we unconditionally included linux/of_device.h, that file does
nothing unless CONFIG_OF_DEVICE is defined so it should have always
produced these warnings since I can't see from where else it could
have gotten even a "struct of_device;" somewhere.

Do you have any idea Randy?  Pease try analyze this further so we can
fix it properly.

THanks!
