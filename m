Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab2C1HM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:12:27 -0400
Received: from [221.122.61.228] ([221.122.61.228]:53072 "EHLO mx.nrchpc.ac.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751467Ab2C1HM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:12:26 -0400
From: "Liu Yu" <liuyums@bwstor.com.cn>
To: <linux-kernel@vger.kernel.org>
Subject: Wrong use of MAX_JIFFY_OFFSET?
Date: Wed, 28 Mar 2012 15:12:24 +0800
Message-ID: <006001cd0cb2$20f547b0$62dfd710$@com.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
thread-index: Ac0LuHcq4+htNpIgTZi70dBijjy9Mw==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I saw a couple of places in current kernel have this kind of code:

> static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
> {
>         unsigned long end = jiffies;
>
>         if (end >= start)
>                return jiffies_to_msecs(end - start);
>
>         return jiffies_to_msecs(end + (MAX_JIFFY_OFFSET - start) + 1);
> }

As you know, jiffies has a type of unsigned long, so if we know which is the
end and
which is the start, then (end - start) can simply figure out how much
jiffies flies,
without worry about the overflow.

Look at the code above, assume that there is just an overflow happening on
jiffies: end=0 and start=~0UL.
Since end < start, then the return value of the function is
jiffies_to_msecs(MAX_JIFFY_OFFSET+2).
But shouldn't the correct value be jiffies_to_msecs(1)?

could someone tell me that am I missing anything?

Thanks,
Yu

