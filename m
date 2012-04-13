Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab2DMPF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 11:05:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49587 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2DMPFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 11:05:31 -0400
Date: Fri, 13 Apr 2012 11:05:21 -0400 (EDT)
Message-Id: <20120413.110521.1849736588108683587.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: eric.dumazet@gmail.com, ericvh@gmail.com, davej@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        levinsasha928@gmail.com, remi.denis-courmont@nokia.com
Subject: Re: [PATCH 2/2] phonet: Sort out initiailziation and cleanup code.
From: David Miller <davem@davemloft.net>
In-Reply-To: <m162dctjbo.fsf_-_@fess.ebiederm.org>
References: <m1mx6otk85.fsf@fess.ebiederm.org>
	<m1aa2otjf4.fsf_-_@fess.ebiederm.org>
	<m162dctjbo.fsf_-_@fess.ebiederm.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 Apr 2012 08:05:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 06 Apr 2012 18:35:39 -0700

> 
> Recently an oops was reported in phonet if there was a failure during
> network namespace creation.
 ...
> After investigation it turns out there were two issues.
> 1) Phonet was not implementing network devices but was using register_pernet_device
>    instead of register_pernet_subsys.
> 
>    This was allowing there to be cases when phonenet was not initialized and
>    the phonet net_generic was not set for a network namespace when network
>    device events were being reported on the netdevice_notifier for a network
>    namespace leading to the oops above.
> 
> 2) phonet_exit_net was implementing a confusing and special case of handling all
>    network devices from going away that it was hard to see was correct, and would
>    only occur when the phonet module was removed.
> 
>    Now that unregister_netdevice_notifier has been modified to synthesize unregistration
>    events for the network devices that are extant when called this confusing special
>    case in phonet_exit_net is no longer needed.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Also applied, thanks Eric.
