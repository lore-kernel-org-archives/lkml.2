Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1EFItx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 04:49:53 -0400
Received: from mailout.rz.uni-frankfurt.de ([141.2.22.233]:54255 "EHLO
	mailout.rz.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216Ab1EFItv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 04:49:51 -0400
Message-ID: <4DC3B629.7010409@gmx.de>
Date: Fri, 06 May 2011 10:49:45 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.X)
References: <4DAF6C0B.3070009@gmx.de> <20110427134613.GI32590@random.random> <4DC14474.9040001@gmx.de> <20110504143842.GK7838@random.random> <4DC31EDE.2020503@gmx.de> <20110506011319.GH7838@random.random>
In-Reply-To: <20110506011319.GH7838@random.random>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You can already run "grep threshold /proc/zoneinfo" on the system
> where you reproduced the hang the last time (the one running 2.6.38.4)
> the one with 1.5G of ram. They all should be well below 512 (so in
> theory not causing troubles because of the per-cpu stats, and with so
> few cpus it shouldn't have been such a longstanding problem anyway).

'grep threshold /proc/zoneinfo' returns nothing on this machine after
a reboot and before a crash. Did I tell it's a single core machine?

> If you didn't reboot that system after the last hang

I'm sorry, I already rebooted the machine.

> grep nr_isolated_anon /proc/zoneinfo 
>     nr_isolated_anon 0
>     nr_isolated_anon 0
>     nr_isolated_anon 0

Same here, on both machines. Both between reboot and crash.

> This patch may help you to reproduce much quicker,

I applied the patch. I plan to boot this kernel within the next hour.

> -	sync_migration = !(gfp_mask & __GFP_NO_KSWAPD);
> +	sync_migration = true;

This was already done in my 2.6.38.2?

Thomas
