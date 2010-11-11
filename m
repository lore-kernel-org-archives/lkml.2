Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab0KKEth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 23:49:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53231
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932316Ab0KKEth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 23:49:37 -0500
Date: Wed, 10 Nov 2010 20:50:01 -0800 (PST)
Message-Id: <20101110.205001.226775444.davem@davemloft.net>
To: pjt@google.com
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu,
        vatsa@in.ibm.com, cfriesen@nortel.com, svaidy@linux.vnet.ibm.com,
        pbourdon@excellency.fr, bharata@linux.vnet.ibm.com, kmr@us.ibm.com,
        balbir@linux.vnet.ibm.com
Subject: Re: [tg_shares_up rewrite v2 10/11] sched: allow update_cfs_load
 to update global load
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101110.204704.193706279.davem@davemloft.net>
References: <20101111035005.443640006@google.com>
	<20101111035051.156752259@google.com>
	<20101110.204704.193706279.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 10 Nov 2010 20:47:04 -0800 (PST)

> From: Paul Turner <pjt@google.com>
> Date: Wed, 10 Nov 2010 19:50:15 -0800
> 
>> Refactor the global load updates from update_shares_cpu() so that
>> update_cfs_load() can update global load when it is more than ~10% out of sync.
>> 
>> The new global_load parameter allows us to force an update, regardless of
>> the error factor so that we can synchronize w/ update_shares().
>> 
>> Signed-off-by: Paul Turner <pjt@google.com>
> 
> This patch breaks the build, you didn't update the arguments of
> update_cfs_load() in the !CONFIG_FAIR_GROUP_SCHED case.

And even with this fixed there are even larger problems, as you're
making access to structure members such as 'load_unacc_exec_time'
which only exist when CONFIG_FAIR_GROUP_SCHED is set, but you're doing
it in code that is built unconditionally.

Please fix all of these build problems, as I want to test your changes
without all of the group scheduler bloat turned on.

Thanks.
