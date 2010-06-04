Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab0FDBth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:49:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170Ab0FDBtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:49:35 -0400
Message-ID: <4C085C9A.30506@redhat.com>
Date: Fri, 04 Jun 2010 09:53:30 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, davem@davemloft.net,
       linux-rdma@vger.kernel.org, sean.hefty@intel.com
Subject: Re: [Patch] infiniband: check local reserved ports
References: <20100603083106.6047.7657.sendpatchset@localhost.localdomain> <ada1vcoqde3.fsf@roland-alpha.cisco.com>
In-Reply-To: <ada1vcoqde3.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/10 00:39, Roland Dreier wrote:
>   >  Since Tetsuo's patch already got merged, now this is the missing part
>   >  for local port reservation.
>   >
>   >  Cc: Roland Dreier<rdreier@cisco.com>
>   >  Cc: Tetsuo Handa<penguin-kernel@i-love.sakura.ne.jp>
>   >  Signed-off-by: WANG Cong<amwang@redhat.com>
>   >
>   >  ---
>   >  diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
>   >  index b930b81..7b89bab 100644
>   >  --- a/drivers/infiniband/core/cma.c
>   >  +++ b/drivers/infiniband/core/cma.c
>   >  @@ -1978,6 +1978,7 @@ static int cma_alloc_any_port(struct idr *ps, struct rdma_id_private *id_priv)
>   >   	rover = net_random() % remaining + low;
>   >   retry:
>   >   	if (last_used_port != rover&&
>   >  +	    !inet_is_reserved_local_port(rover)&&
>   >   	!idr_find(ps, (unsigned short) rover)) {
>   >   		int ret = cma_alloc_port(ps, id_priv, rover);
>   >   		/*
>
> Should this inet_is_reserved_local_port() test apply to all the "port
> spaces" that this code is handling?  I honestly am ignorant of the
> intended semantics of the new local_reserved_ports stuff, hence my question.
>

Yes, but I only found this case, is there any else?

Thanks!
