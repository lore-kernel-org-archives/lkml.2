Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab2A0Mu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 07:50:26 -0500
Received: from mx2.parallels.com ([64.131.90.16]:36561 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298Ab2A0MuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 07:50:25 -0500
Message-ID: <4F229D5C.4040300@parallels.com>
Date: Fri, 27 Jan 2012 16:49:32 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [v3.3-rc1 regression] TCP: too many of orphaned sockets
References: <20120127124641.GA30819@elte.hu>
In-Reply-To: <20120127124641.GA30819@elte.hu>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [188.255.67.4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 04:46 PM, Ingo Molnar wrote:
>
> There's a new TCP regression in latest -git that triggers in
> randconfig testing.
>
> With the attached config i'm getting tons of these messages:
>
> [   32.751209] TCP: too many of orphaned sockets
> [   37.198307] TCP: too many of orphaned sockets
> [   42.464404] TCP: too many of orphaned sockets
> [   48.920392] TCP: too many of orphaned sockets
> [   56.370026] TCP: too many of orphaned sockets
> [   64.605937] TCP: too many of orphaned sockets
>
> and it's not possible to ssh into the testbox, the TCP
> connection hangs.
>
> Before i put more effort into debugging this, is this bug
> already known/fixed?
>
> NOTE: the .config is randconfig generated so it might have a few
> weird combinations of config options. One such thing i noticed
> is !CONFIG_BUG, this produces at least one of the following
> build warnings in the networking code:
>
> net/core/ethtool.c:211:1: warning: control reaches end of non-void function [-Wreturn-type]
> net/core/dev.c:1892:33: warning: unused variable ‘null_features’ [-Wunused-variable]
> net/packet/af_packet.c:1878:30: warning: ‘hdrlen’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> net/xfrm/xfrm_policy.c:2456:17: warning: ‘xfrm_dst_ops’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> net/xfrm/xfrm_policy.c:1351:7: warning: ‘dst_ops’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> net/xfrm/xfrm_policy.c:1333:18: note: ‘dst_ops’ was declared here
> net/xfrm/xfrm_policy.c:1351:7: warning: ‘dst_ops’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> net/xfrm/xfrm_policy.c:1333:18: note: ‘dst_ops’ was declared here
>
> Note#2, the message should probably be fixed as well:
>
>   -   TCP: too many of orphaned sockets
>   +   TCP: too many orphaned sockets
>
> Thanks,
>
> 	Ingo

Ingo,
mind sharing your config?

I haven't seen this, but I intend to run this against my recent 
patchseries and at least see if this is the culprit.

Thanks.
