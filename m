Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161550Ab2CPKe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:34:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37252 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760368Ab2CPKe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:34:26 -0400
Date: Fri, 16 Mar 2012 03:32:04 -0700 (PDT)
Message-Id: <20120316.033204.2200537098677808280.davem@davemloft.net>
To: peterz@infradead.org
Cc: steffen.klassert@secunet.com, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: cpu_active vs pcrypt & padata
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331893215.18960.228.camel@twins>
References: <1331892788.18960.227.camel@twins>
	<20120316.031644.577275447313181686.davem@davemloft.net>
	<1331893215.18960.228.camel@twins>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 16 Mar 2012 03:32:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Fri, 16 Mar 2012 11:20:15 +0100

> On Fri, 2012-03-16 at 03:16 -0700, David Miller wrote:
>> From: Peter Zijlstra <peterz@infradead.org>
>> Date: Fri, 16 Mar 2012 11:13:08 +0100
>> 
>> > Also, wth is all this kernel/padata.c stuff? There's next to no useful
>> > comment in there and the only consumer seems to be pcrypt, does that
>> > really need to be in kernel/ ?
>> 
>> There's really nothing specific to crypto in that padata.c file,
>> anything trying to compute things in parallel with some kind
>> of converging synchronization points can use that code.
> 
> So why isn't anybody else using that? Don't the block/fs people need
> similar things?

Beats me, but just because there's only one user doesn't mean it belongs
tucked away in that one user's subsystem.
