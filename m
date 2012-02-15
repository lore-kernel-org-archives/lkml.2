Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab2BOTWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:22:14 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:38846 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab2BOTWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:22:12 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 15 Feb 2012 20:21:35 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 05/11] firewire-sbp-target: Add sbp_configfs.c
Message-ID: <20120215202135.61165ee0@stein>
In-Reply-To: <1329317248-94128-6-git-send-email-bootc@bootc.net>
References: <1328989452-20921-1-git-send-email-bootc@bootc.net>
	<1329317248-94128-1-git-send-email-bootc@bootc.net>
	<1329317248-94128-6-git-send-email-bootc@bootc.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 15 Chris Boot wrote:
> --- /dev/null
> +++ b/drivers/target/sbp/sbp_configfs.c
> @@ -0,0 +1,751 @@
> +/*
> + * SBP2 target driver (SCSI over IEEE1394 in target mode)
> + *
> + * Copyright (C) 2011  Chris Boot <bootc@bootc.net>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software Foundation,
> + * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + */
> +
> +#define KMSG_COMPONENT "sbp_target"
> +#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/version.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/kthread.h>
> +#include <linux/types.h>
> +#include <linux/string.h>
> +#include <linux/configfs.h>
> +#include <linux/ctype.h>
> +#include <linux/firewire.h>
> +
> +#include <asm/unaligned.h>
> +
> +#include <target/target_core_base.h>
> +#include <target/target_core_backend.h>
> +#include <target/target_core_fabric.h>
> +#include <target/target_core_configfs.h>
> +#include <target/target_core_fabric_configfs.h>
> +#include <target/configfs_macros.h>
> +
> +#include "sbp_base.h"
> +#include "sbp_fabric.h"
> +#include "sbp_management_agent.h"
> +
> +/* Local pointer to allocated TCM configfs fabric module */
> +struct target_fabric_configfs *sbp_fabric_configfs;
> +
> +struct workqueue_struct *sbp_workqueue;

#include <linux/workqueue.h> goes before this.

[...]
> +	sbp_workqueue = alloc_workqueue("firewire-sbp-target", WQ_UNBOUND, 0);
> +	if (!sbp_workqueue) {
> +		target_fabric_configfs_deregister(fabric);
> +		return -ENOMEM;
> +	}

What are your specific requirements that you cannot use one of the
system-wide workqueues?
-- 
Stefan Richter
-=====-===-- --=- -====
http://arcgraph.de/sr/
