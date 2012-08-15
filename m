Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab2HOWM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 18:12:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52442 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab2HOWMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 18:12:25 -0400
Date: Wed, 15 Aug 2012 15:12:23 -0700 (PDT)
Message-Id: <20120815.151223.1108632083114612511.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: jiri@resnulli.us, netdev@vger.kernel.org, edumazet@google.com,
        faisal.latif@intel.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, fubar@us.ibm.com, andy@greyhouse.net,
        divy@chelsio.com, jitendra.kalsaria@qlogic.com, sony.chacko@qlogic.com,
        linux-driver@qlogic.com, kaber@trash.net, ursula.braun@de.ibm.com,
        blaschka@linux.vnet.ibm.com, linux390@de.ibm.com,
        shemminger@vyatta.com, therbert@google.com, xiyou.wangcong@gmail.com,
        joe@perches.com, gregory.v.rose@intel.com, john.r.fastabend@intel.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, bridge@lists.linux-foundation.org,
        fbl@redhat.com
Subject: Re: [patch net-next v2 01/15] net: introduce upper device lists
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344983624.2690.77.camel@bwh-desktop.uk.solarflarecom.com>
References: <1344956748-2099-1-git-send-email-jiri@resnulli.us>
	<1344956748-2099-2-git-send-email-jiri@resnulli.us>
	<1344983624.2690.77.camel@bwh-desktop.uk.solarflarecom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Tue, 14 Aug 2012 23:33:44 +0100

> I think we will also need to limit the depth of the device stack so we
> don't run out of stack space here.  __netif_receive() implements a kind
> of tail recursion whenever a packet is passed up, but
> __netdev_has_upper_dev() can't avoid doing real recursion (without the
> addition of a flag to net_device so it can mark its progress).

Agreed, we need some kind of limit here.
