Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab0DKVnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 17:43:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42363
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862Ab0DKVnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 17:43:10 -0400
Date: Sun, 11 Apr 2010 14:43:13 -0700 (PDT)
Message-Id: <20100411.144313.71127091.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: ssh server etc doesn't work anymore with net-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100411120403.GA20565@gondor.apana.org.au>
References: <20100411100902.GA20141@gondor.apana.org.au>
	<20100411120403.GA20565@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sun, 11 Apr 2010 20:04:03 +0800

> Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> 
>> After looking at the actual net-2.6 tree I see that it is actually
>> CHECKSUM_PARTIAL that caused this breakage.
>> 
>> The fact that when this was first implemented we didn't use hw
>> checksums on dataless packets might not have been an oversight
>> after all.
> 
> Looks like I was too quick to blame the hardware, the synack
> code can't handle CHECKSUM_PARTIAL so this is probably the real
> cause.
> 
> I will send patches to fix this.

Thanks a lot for figuring this out.

I'll put my original patch (with fixed commit log message!)
and your fixes into net-next-2.6
