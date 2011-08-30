Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab1H3WGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:06:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:35703 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab1H3WGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:06:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="43786136"
Message-ID: <4E5D5EE6.3070708@linux.intel.com>
Date: Tue, 30 Aug 2011 15:06:30 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH 2/4] posix-timers: limit the number of posix timers per
 process
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>	<1314661157-22173-2-git-send-email-andi@firstfloor.org> <20110830144407.acdae071.akpm@linux-foundation.org>
In-Reply-To: <20110830144407.acdae071.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Sorry, it should be an rlimit from day one, IMO.
>

Ok.

> Partly because rlimits are a better implementation.

The reason I went with a sysctl is that rlimits are more intrusive for 
user space,
requires special tools or patching bash.

> Partly because once rlimits are added, the /proc knob no longer has any
> sane behaviour.  Does it only modify /sbin/init?  Does it do a global
> process walk, modifying all threads?

There's no way to modify: you would need to kill the process or randomly
take timers away. The limit only applies to new timers.

-Andi

