Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab1GGLgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:36:36 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42307 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab1GGLgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 07:36:33 -0400
Date: Thu, 07 Jul 2011 04:36:25 -0700 (PDT)
Message-Id: <20110707.043625.856190521365086318.davem@davemloft.net>
To: abbotti@mev.co.uk
Cc: ian.abbott@mev.co.uk, netdev@vger.kernel.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/checksum.c: optimize do_csum a bit
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E15995D.6040405@mev.co.uk>
References: <1310037529-30854-1-git-send-email-abbotti@mev.co.uk>
	<20110707.042925.1609726410655229616.davem@davemloft.net>
	<4E15995D.6040405@mev.co.uk>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 07 Jul 2011 04:36:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>
Date: Thu, 7 Jul 2011 12:32:45 +0100

> On 07/07/11 12:29, David Miller wrote:
>> From: Ian Abbott <abbotti@mev.co.uk>
>> Date: Thu, 7 Jul 2011 12:18:49 +0100
>> 
>>> Reduce the number of variables modified by the loop in do_csum() by 1,
>>> which seems like a good idea.  On Nios II (a RISC CPU with 3-operand
>>> instruction set) it reduces the loop from 7 to 6 instructions, including
>>> the conditional branch.
>>>
>>> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
>> 
>> I think you'll overshoot past the end of the buffer when there are
>> trailing bytes to handle.
>> 
>> The whole reason we need the count variable is to handle those
>> kinds of cases.
> 
> I don't think it does.  That's what the & ~3 was for.

Aha, yes that indeed makes it work.
