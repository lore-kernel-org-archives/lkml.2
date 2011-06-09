Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1FIDCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 23:02:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:14992 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab1FIDCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:02:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,340,1304319600"; 
   d="scan'208";a="9646134"
Message-ID: <4DF037C6.4000507@linux.intel.com>
Date: Wed, 08 Jun 2011 20:02:30 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: david@rgmadvisors.com, kyle@moffetthome.net, luto@mit.edu,
        linux-kernel@vger.kernel.org
Subject: Re: Change in functionality of futex() system call.
References: <20110609004435.14550.qmail@science.horizon.com>
In-Reply-To: <20110609004435.14550.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 05:44 PM, George Spelvin wrote:
> I'm not sure if it's best, but the risk of RO waiters interfering could
> be solved by giving them a lower prioirty for wakeup and always waking
> RW-mapped waiters first.

This strikes me as bending over backwards and jumping through hoops
inside the kernel to avoid having to do proper permissions management in
userspace.


> In most cases, there would only be one type of waiter, so this would
> have no effect, but if there were, a RO-mapped reader couldn't "steal"
> wakeup from someone who had it RW-mapped.
> 
> It might conflict with a fairness goal, but it does solve the problem
> without any extension to the API.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
