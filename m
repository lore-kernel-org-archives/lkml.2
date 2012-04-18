Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2DRTE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:04:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45440 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab2DRTE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:04:58 -0400
Date: Wed, 18 Apr 2012 14:04:50 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: "Peter Huang (Peng)" <peter.huangpeng@huawei.com>
Cc: shemminger@vyatta.com, "'David S. Miller'" <davem@davemloft.net>,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org, ctrix+debianbugs@navynet.it,
        peter.huangpeng@gmail.com, harry.majun@huawei.com
Subject: Re: [PATCH] set fake_rtable's dst to NULL to avoid kernel Oops.
Message-ID: <20120418190450.GA30185@burratino>
References: <000001cd1c62$75d10de0$617329a0$%huangpeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cd1c62$75d10de0$617329a0$%huangpeng@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Peter Huang (Peng) wrote:

> When bridge is deleted before tap/vif device's delete, kernel may
> encounter an oops because of NULL reference to fake_rtable's dst.
>
> Set fake_rtable's dst to NULL before sending packets out can solve
> this problem.
>
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Peter Huang <peter.huangpeng@huawei.com>
> ---
> include/linux/netfilter_bridge.h |    8 ++++++++
>  net/bridge/br_forward.c          |    1 +
>  net/bridge/br_netfilter.c        |    6 +-----
>  3 files changed, 10 insertions(+), 5 deletions(-)

Massimo Cetra (cc-ed) tested the patch against a 3.2.y kernel and wrote[1]:

> The patch i applied yesterday to the debian kernel has been installed 
> and the kernel is not panic-ing anymore.
>
> I'll try to keep this bug up to date.

So it seems to work.  Dave, please consider queuing this for stable@
when the final patch is ready.

Thanks,
Jonathan

[1] http://bugs.debian.org/668511#37
