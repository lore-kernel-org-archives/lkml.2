Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab2BPJ5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:57:35 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:46527 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2BPJ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:57:31 -0500
Message-ID: <4F3CD307.4020008@bootc.net>
Date: Thu, 16 Feb 2012 09:57:27 +0000
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 05/11] firewire-sbp-target: Add sbp_configfs.c
References: <1328989452-20921-1-git-send-email-bootc@bootc.net> <1329317248-94128-1-git-send-email-bootc@bootc.net> <1329317248-94128-6-git-send-email-bootc@bootc.net> <20120215202135.61165ee0@stein>
In-Reply-To: <20120215202135.61165ee0@stein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/02/2012 19:21, Stefan Richter wrote:
> On Feb 15 Chris Boot wrote:
>> --- /dev/null
>> +++ b/drivers/target/sbp/sbp_configfs.c
>> @@ -0,0 +1,751 @@
>> +/*
>> + * SBP2 target driver (SCSI over IEEE1394 in target mode)
>> + *
>> + * Copyright (C) 2011  Chris Boot<bootc@bootc.net>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software Foundation,
>> + * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
>> + */
>> +
>> +#define KMSG_COMPONENT "sbp_target"
>> +#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
>> +
>> +#include<linux/module.h>
>> +#include<linux/moduleparam.h>
>> +#include<linux/version.h>
>> +#include<linux/init.h>
>> +#include<linux/slab.h>
>> +#include<linux/kthread.h>
>> +#include<linux/types.h>
>> +#include<linux/string.h>
>> +#include<linux/configfs.h>
>> +#include<linux/ctype.h>
>> +#include<linux/firewire.h>
>> +
>> +#include<asm/unaligned.h>
>> +
>> +#include<target/target_core_base.h>
>> +#include<target/target_core_backend.h>
>> +#include<target/target_core_fabric.h>
>> +#include<target/target_core_configfs.h>
>> +#include<target/target_core_fabric_configfs.h>
>> +#include<target/configfs_macros.h>
>> +
>> +#include "sbp_base.h"
>> +#include "sbp_fabric.h"
>> +#include "sbp_management_agent.h"
>> +
>> +/* Local pointer to allocated TCM configfs fabric module */
>> +struct target_fabric_configfs *sbp_fabric_configfs;
>> +
>> +struct workqueue_struct *sbp_workqueue;
>
> #include<linux/workqueue.h>  goes before this.

Yep.

> [...]
>> +	sbp_workqueue = alloc_workqueue("firewire-sbp-target", WQ_UNBOUND, 0);
>> +	if (!sbp_workqueue) {
>> +		target_fabric_configfs_deregister(fabric);
>> +		return -ENOMEM;
>> +	}
>
> What are your specific requirements that you cannot use one of the
> system-wide workqueues?

Nothing specific, I just thought it was sensible to use your own 
workqueue if you put enough work into it. I'll switch to the system queues.

-- 
Chris Boot
bootc@bootc.net
