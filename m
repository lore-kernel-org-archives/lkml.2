Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab1GFVqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:46:46 -0400
Received: from mail.perches.com ([173.55.12.10]:3610 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab1GFVqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:46:45 -0400
Subject: Re: [PATCH 01/10] dynamic_debug: Add __dynamic_dev_dbg
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        aloisio.almeida@openbossa.org, netdev@vger.kernel.org
In-Reply-To: <6d176b4a9fa316e5130455b6a6b47ba1dd0501d5.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
References: <cover.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
	 <6d176b4a9fa316e5130455b6a6b47ba1dd0501d5.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 14:46:43 -0700
Message-ID: <1309988803.1710.10.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-06 at 13:24 -0400, Jason Baron wrote:
> Unlike dynamic_pr_debug, dynamic uses of dev_dbg can not
> currently add task_pid/KBUILD_MODNAME/__func__/__LINE__
> to selected debug output.
> Add a new function similar to dynamic_pr_debug to
> optionally emit these prefixes.
[]
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
[]
> @@ -456,6 +457,43 @@ int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
[]
> +int __dynamic_dev_dbg(struct _ddebug *descriptor,
> +		      const struct device *dev, const char *fmt, ...)
[]
> +	res += __dev_printk("", dev, &vaf);

I suppose that should more properly be written as:

	res += __dev_printk(KERN_CONT, dev, &vaf);


