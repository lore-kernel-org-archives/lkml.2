Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab1F1UhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 16:37:05 -0400
Received: from mail.solarflare.com ([216.237.3.220]:11921 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1F1Ug7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 16:36:59 -0400
Subject: Re: [PATCH] net/core: Convert to current logging forms
From: Ben Hutchings <bhutchings@solarflare.com>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1309293068.29598.14.camel@Joe-Laptop>
References: <385ebf7e98e377e6e6c384beb961b65d4a95fb18.1309289792.git.joe@perches.com>
	 <1309292501.2771.48.camel@bwh-desktop>
	 <1309293068.29598.14.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Tue, 28 Jun 2011 21:36:56 +0100
Message-ID: <1309293416.2771.50.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2011 20:36:59.0584 (UTC) FILETIME=[210E0400:01CC35D3]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18226.005
X-TM-AS-Result: No--16.890500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 13:31 -0700, Joe Perches wrote:
> On Tue, 2011-06-28 at 21:21 +0100, Ben Hutchings wrote:
> > On Tue, 2011-06-28 at 12:40 -0700, Joe Perches wrote:
> > > Use pr_fmt, pr_<level>, and netdev_<level> as appropriate.
> > > Coalesce long formats.
> > [...]
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -72,6 +72,8 @@
> > > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > [...]
> > KBUILD_MODNAME is presumably going to be "dev".
> 
> 'tis.
> 
> > That's not very meaningful.
> 
> I think it's not useless though.
>
> Anything else you think it should be?
> Maybe "net_core_device:" or some such like that?

"netdev"

> Here are the format strings now prefaced by "dev:"
> 
> $ strings net/core/built-in.o |grep "^<.>dev:"
> <6>dev: netif_stop_queue() cannot be called before register_netdev()
> <4>dev: dev_remove_pack: %p not found
> <3>dev: Loading kernel module for a network device with CAP_SYS_MODULE (deprecated)
> <0>dev: %s: failed to move %s to init_net: %d
> <3>dev: alloc_netdev: Unable to allocate device with zero queues
> <3>dev: alloc_netdev: Unable to allocate device with zero RX queues
> <3>dev: alloc_netdev: Unable to allocate device

Many of these refer to a specific device and should be formatted with
one of the netdev_* logging functions.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

