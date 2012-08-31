Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab2HaTmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 15:42:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52896 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab2HaTmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 15:42:39 -0400
Date: Fri, 31 Aug 2012 15:42:34 -0400 (EDT)
Message-Id: <20120831.154234.735439593093335863.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: alex@linlab.net, hkjerry.chu@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tcp: Wrong timeout for SYN segments
From: David Miller <davem@davemloft.net>
In-Reply-To: <1346419550.2591.12.camel@edumazet-glaptop>
References: <1346414260.2591.8.camel@edumazet-glaptop>
	<20120831124831.GA23279@linlab.net>
	<1346419550.2591.12.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 31 Aug 2012 06:25:50 -0700

> On Fri, 2012-08-31 at 14:48 +0200, Alexander Bergmann wrote:
> 
>> Hi Eric!
>> 
>> I've also changed the Documentation file. As usual, comments are welcome!
>> 
>> 
>> Alex
>> 
>> 
>> From 848f34ce27f65401940ae98e0b2d395888d3986d Mon Sep 17 00:00:00 2001
>> From: Alexander Bergmann <alex@linlab.net>
>> Date: Fri, 31 Aug 2012 14:31:00 +0200
>> Subject: [PATCH 1/1] tcp: Increase timeout for SYN segments
>> 
>> Commit 9ad7c049 changed the initRTO from 3secs to 1sec in accordance to
>> RFC6298 (former RFC2988bis). This reduced the time till the last SYN
>> retransmission packet gets sent from 93secs to 31secs.
>> 
>> RFC1122 is stating that the retransmission should be done for at least 3
>> minutes, but this seems to be quite high.
>> 
>>   "However, the values of R1 and R2 may be different for SYN
>>   and data segments.  In particular, R2 for a SYN segment MUST
>>   be set large enough to provide retransmission of the segment
>>   for at least 3 minutes.  The application can close the
>>   connection (i.e., give up on the open attempt) sooner, of
>>   course."
>> 
>> This patch increases the value of TCP_SYN_RETRIES to the value of 6,
>> providing a retransmission window of 63secs.
>> 
>> The comments for SYN and SYNACK retries have also been updated to
>> describe the current settings. The same goes for the documentation file
>> "Documentation/networking/ip-sysctl.txt".
>> 
>> Signed-off-by: Alexander Bergmann <alex@linlab.net>
>> ---
> 
> Thanks for your patience and followup, this seems good to me !
> 
> Acked-by: Eric Dumazet <edumazet@google.com>

Applied with some minor comment formatting and wording adjustments.

Thanks everyone.
