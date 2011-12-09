Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab1LIUYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:24:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:18394 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab1LIUYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:24:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="85537859"
Message-ID: <4EE26E8F.9010000@linux.intel.com>
Date: Fri, 09 Dec 2011 12:24:47 -0800
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        kay.sievers@vrfy.org, trenn@suse.de, davej@redhat.com, axboe@kernel.dk,
        hpa@zytor.com, herbert@gondor.hengli.com.au, ying.huang@intel.com,
        lenb@kernel.org
Subject: Re: [PATCH 01/10] Add driver auto probing for x86 features
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>	<1323304882-27953-2-git-send-email-andi@firstfloor.org>	<20111208103540.4778b896@endymion.delvare>	<20111208144516.GE24062@one.firstfloor.org> <20111209211601.08dabc88@endymion.delvare>
In-Reply-To: <20111209211601.08dabc88@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Can you guarantee that there is no asymmetric system already working
> today?

I used to have an asymmetric system myself, but we generally subset the 
CPU feature
flags to be the same everywhere and I didn't change any per CPU stepping 
checks
as they were there.

>   If you can't, then your approach could cause a regression. This
> is why I am asking for an API change to let drivers pass a specific CPU
> to x86_match_cpu(). There are at least two drivers who would take
> benefit of this. Your patch set is supposed to only add driver
> auto-loading, and while cleaning up the code in the process is nice, I
> think you should avoid driver behavior changes, these are out of scope
> for such a patch set.

I undoed that change to the coretemp driver and there's no other AFAIK.
Generally most drivers only check the boot cpu.

-Andi
