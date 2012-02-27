Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2B0VbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:31:00 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:36788 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab2B0Va6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:30:58 -0500
Date: Mon, 27 Feb 2012 16:30:44 -0500 (EST)
Message-Id: <20120227.163044.2168482307021109001.davem@davemloft.net>
To: mroos@linux.ee
Cc: sam@ravnborg.org, tj@kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1202272316280.15067@math.ut.ee>
References: <alpine.SOC.1.00.1202271914310.15067@math.ut.ee>
	<20120227194341.GA1448@merkur.ravnborg.org>
	<alpine.SOC.1.00.1202272316280.15067@math.ut.ee>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 27 Feb 2012 13:30:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Mon, 27 Feb 2012 23:25:11 +0200 (EET)

>> Could you try to give this a quick spin and see if something
>> turns up. I you have time it would be good to try on a box
>> that worked before and one that was fixed by the patch from Tejun.
> 
> Neither of the machines - already working one and "fixed with the 
> rounding patch" one emit any prot: messages.

I think the issue is that OF writes past the end of the buffer even
though the length it reports is smaller than what it writes.

That's why we really need to fill the memblock memory with magic
numbers and scan every allocation for free memory with corrupted
magic values.
