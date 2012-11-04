Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2KDVEH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 16:04:07 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:50089 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275Ab2KDVEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 16:04:05 -0500
X-IronPort-AV: E=Sophos;i="4.80,711,1344204000"; 
   d="scan'208";a="180088760"
Date: Sun, 4 Nov 2012 22:04:01 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Arnd Bergmann <arnd@arndb.de>
cc: Julia Lawall <julia.lawall@lip6.fr>, walter harms <wharms@bfs.de>,
        kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/misc/kgdbts.c: remove eprintk
In-Reply-To: <201211042051.58473.arnd@arndb.de>
Message-ID: <alpine.DEB.2.02.1211042202240.1960@localhost6.localdomain6>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr> <201211041939.51608.arnd@arndb.de> <alpine.DEB.2.02.1211042051190.1960@localhost6.localdomain6> <201211042051.58473.arnd@arndb.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2012, Arnd Bergmann wrote:

> On Sunday 04 November 2012, Julia Lawall wrote:
>
>>> Hmm, I did not think that WARN() took a KERN_ERR argument, which should
>>> really be implied here. Looking at the code, it really seems to be required
>>> at the moment, but only 5 out of 117 callers use it this way.
>>>
>>> Any idea what is going on here?
>>
>> I'm not sure to understand the 5 and 117.  Using grep, I get 30 with
>> KERN_ERR, 61 with some KERN thing, and 1207 without KERN.
>
> Right, I was using 'grep -w', which misses a lot of the instances, although
> I see still much fewer in the last category.
>
>> If things are
>> set up such that warn_slowpath_fmt is called, then that function adds
>> KERN_WARNING.  There is an alternate definition of __WARN_printf that just
>> does a printk.
>
> I don't see yet where that KERN_WARNING gets added. Looking at
> warn_slowpath_common, there are two or three lines that get printed at
> KERN_WARNING level, followed by the format that got passed into WARN(),
> which may or may not include a printk level, but I don't see one getting
> added.

OK, I agree.  There are lots of KERN_WARNINGs, but not on the string that 
was passed in.  Still, maybe it is not so good to pass a KERN_XXX for some 
other XXX to WARN.

julia
