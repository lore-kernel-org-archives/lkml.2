Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab2HNXBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:01:11 -0400
Received: from mail.vyatta.com ([76.74.103.46]:59198 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab2HNXBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:01:08 -0400
Date: Tue, 14 Aug 2012 16:00:55 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <faisal.latif@intel.com>,
        <roland@kernel.org>, <sean.hefty@intel.com>,
        <hal.rosenstock@gmail.com>, <fubar@us.ibm.com>, <andy@greyhouse.net>,
        <divy@chelsio.com>, <jitendra.kalsaria@qlogic.com>,
        <sony.chacko@qlogic.com>, <linux-driver@qlogic.com>, <kaber@trash.net>,
        <ursula.braun@de.ibm.com>, <blaschka@linux.vnet.ibm.com>,
        <linux390@de.ibm.com>, <therbert@google.com>,
        <xiyou.wangcong@gmail.com>, <joe@perches.com>,
        <gregory.v.rose@intel.com>, <john.r.fastabend@intel.com>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        <fbl@redhat.com>
Subject: Re: [patch net-next v2 01/15] net: introduce upper device lists
Message-ID: <20120814160055.1e948456@nehalam.linuxnetplumber.net>
In-Reply-To: <1344983624.2690.77.camel@bwh-desktop.uk.solarflarecom.com>
References: <1344956748-2099-1-git-send-email-jiri@resnulli.us>
	<1344956748-2099-2-git-send-email-jiri@resnulli.us>
	<1344983624.2690.77.camel@bwh-desktop.uk.solarflarecom.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012 23:33:44 +0100
Ben Hutchings <bhutchings@solarflare.com> wrote:

> On Tue, 2012-08-14 at 17:05 +0200, Jiri Pirko wrote:
> > This lists are supposed to serve for storing pointers to all upper devices.
> > Eventually it will replace dev->master pointer which is used for
> > bonding, bridge, team but it cannot be used for vlan, macvlan where
> > there might be multiple upper present. In case the upper link is
> > replacement for dev->master, it is marked with "master" flag.
> 
> Something I found interesting is that the dev->master pointer and now
> netdev_master_upper_dev_get{,_rcu}() are hardly used by the stackled
> drivers that set the master.  They also have to set an rx_handler on the
> lower device (which is itself mutually exclusive) which gets its own
> context pointer (rx_handler_data).
> 
> Instead, the master pointer is mostly used by device drivers to find out
> about a bridge or bonding device above *their* devices.  And that seems
> to work only for those specific device drivers, not e.g. openvswitch or
> team.  I wonder if we could find a better way to encapsulate the things
> they want do do, in a later step (not holding up this change!).

The concept is master is very useful to user level config things like
Vyatta for seeing parent/child relationship. Since is in ABI now, it
must stay.

