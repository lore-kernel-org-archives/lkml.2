Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0CWEog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 00:44:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab0CWEoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 00:44:34 -0400
Message-ID: <4BA847EB.9040808@redhat.com>
Date: Tue, 23 Mar 2010 12:47:39 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mpm@selenic.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, gospo@redhat.com,
       nhorman@tuxdriver.com, shemminger@linux-foundation.org,
       bonding-devel@lists.sourceforge.net, fubar@us.ibm.com,
       jmoyer@redhat.com
Subject: Re: [RFC Patch 1/3] netpoll: add generic support for bridge and bonding
 devices
References: <20100322082059.4967.63492.sendpatchset@localhost.localdomain>	<1269297081.3552.19.camel@calx>	<4BA823D7.4010106@redhat.com> <20100322.204939.146100390.davem@davemloft.net>
In-Reply-To: <20100322.204939.146100390.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Cong Wang <amwang@redhat.com>
> Date: Tue, 23 Mar 2010 10:13:43 +0800
> 
>> Matt Mackall wrote:
>>> Seems like a lot of interface for something to be used by only a
>>> couple
>>> core drivers. Hopefully Dave has an opinion here.
>>>
>> Yeah, I worry about this too, maybe we can group those methods
>> for netpoll together into another struct, and just put a pointer
>> here?
> 
> This looks like it's tackled at the wrong layer, to be honest.
> 
> Teaching all of these layers about eachother's states is
> going to end up being a nightmare in the end.
> 
> All of this "where is the npinfo" business can be handled
> generically in net/core/dev.c I think, with none of these
> callbacks.
> 
> For example, something like "if dev lacks ->npinfo, check
> it's master".

This is a good point! I haven't tried but certainly this is
worthy a try. Ideally those callbacks can be all removed,
but I don't know if this is true practically. ;)

I will try.

> 
> Another thing, I wouldn't iterate over all devices, like I
> see in the bonding poll controller method.  Just whichever
> one supports netpoll you see first, use it and exit
> immediately.  Don't send it to every single port, I can't
> see how that might be desirable or useful.

Yeah, for bonding case, probably. But for bridge case, I think
we still need to check all, right?

Thanks!
