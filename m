Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab2BRVcY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 16:32:24 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53092 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753461Ab2BRVcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 16:32:24 -0500
Message-ID: <1329600742.1753.20.camel@joe2Laptop>
Subject: Re: [PATCH 3/4] firewire: net: prefix all log messages with
 interface name
From: Joe Perches <joe@perches.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Sat, 18 Feb 2012 13:32:22 -0800
In-Reply-To: <20120218220233.5d67b31a@stein>
References: <20120218215824.5b2359bf@stein> <20120218220233.5d67b31a@stein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-18 at 22:02 +0100, Stefan Richter wrote:
> Change the log line prefix from "firewire_net: " to
> "firewire_net firewire0: " etc. for the case that several RFC 2734
> interfaces are being used in the same machine.

Why not just "firewireX: " ?

[]
> +#define fwnet_notice(net, fmt, args...) \
> +	printk(KERN_NOTICE "%s %s: " fmt, KBUILD_MODNAME, (net)->name, ## args)
> +#define fwnet_err(net, fmt, args...) \
> +	printk(KERN_ERR "%s %s: " fmt, KBUILD_MODNAME, (net)->name, ## args)

Adding code for the "%s:...", KBUILD_MODNAME rarely saves
overall space.  Did you try embedding KBUILD_MODNAME
without the "%s: " and comparing the size?

Perhaps just add pr_fmt and pr_<level>?

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt 	/* (if really necessary) */

and

#define fwnet_notice(net, fmt, ...)		\
	pr_notice("%s: " fmt, (net)->name, ##__VA_ARGS__)
#define fwnet_err(net, fmt, ...)		\
	pr_err("%s: " fmt, (net)->name, ##__VA_ARGS__)


