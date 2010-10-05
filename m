Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab0JEVEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:04:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45079 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141Ab0JEVEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:04:06 -0400
Message-ID: <4CAB92B0.2030707@ti.com>
Date: Tue, 5 Oct 2010 16:03:44 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Kevin Hilman <khilman@deeprootsystems.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Paul <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v5] power: introduce library for device-specific OPPs
References: <1285933174-24053-1-git-send-email-nm@ti.com>	<201010050036.23179.rjw@sisk.pl> <4CAB228C.7030902@ti.com>	<201010052244.11403.rjw@sisk.pl> <8739skpdo9.fsf@deeprootsystems.com>
In-Reply-To: <8739skpdo9.fsf@deeprootsystems.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Hilman had written, on 10/05/2010 03:50 PM, the following:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
>> On Tuesday, October 05, 2010, Nishanth Menon wrote:
>>> Rafael J. Wysocki had written, on 10/04/2010 05:36 PM, the following:
>>>> On Friday, October 01, 2010, Nishanth Menon wrote:
> 
> [...]
> 
>>>> I'm not really sure why so many mutexes are needed here.  I don't think you
>>>> need a separate mutex in every struct device_opp object.  I'd just use
>>>> dev_opp_list_lock for everything.
>>> I did consider using  dev_opp_list_lock to lock everything *but* here is 
>>> the contention:
>>>
>>> dev_opp_list_lock locks modification for addition of domains device. 
>>> This operation happens usually during init stage.
>>>
>>> each domain device has multiple opps, new opps can be added, but the 
>>> more often usage will probably be opp_enable and disable. domain are 
>>> usually modifiable independent of each other - device_opp->lock provides 
>>> device level lock allowing for each domain device opp list to be 
>>> modified independent of each other. e.g. on thermal overage we may 
>>> choose to lower mpu domain while a coprocessor driver in parallel might 
>>> choose to disable co-processor domain in parallel.
>>>
>>> Wondering why you'd like a single lock for all domains and restrict 
>>> parallelization?
>> Because of the simplicity, mostly.  If there's only a relatively short period
>> when the lock will be contended for, that still is not too bad and it's much
>> easier to get the synchronization right with just one lock for starters.
> 
> FWIW, I agree with Rafael
> 
> These are not going be highly contended locks, and the lock durations
> are very short, so simplifying the locking is a big win for readability.
> 
> Kevin
Fair enough. we can relook if the lock becomes a contended lock in the 
future. I do agree that simplifying the locking will benefit 
readability. Will post a v6 with a singular lock and updated 
documentation for the same.

-- 
Regards,
Nishanth Menon
