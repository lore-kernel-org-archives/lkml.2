Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab0FCQjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:39:25 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:32275 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab0FCQjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:39:22 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAL93B0yrR7Ht/2dsb2JhbACeJXGlZ5oUhRYEg0g
X-IronPort-AV: E=Sophos;i="4.53,355,1272844800"; 
   d="scan'208";a="138930733"
From: Roland Dreier <rdreier@cisco.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, davem@davemloft.net,
       linux-rdma@vger.kernel.org, sean.hefty@intel.com
Subject: Re: [Patch] infiniband: check local reserved ports
References: <20100603083106.6047.7657.sendpatchset@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 03 Jun 2010 09:39:16 -0700
In-Reply-To: <20100603083106.6047.7657.sendpatchset@localhost.localdomain>
	(Amerigo Wang's message of "Thu, 3 Jun 2010 04:27:02 -0400")
Message-ID: <ada1vcoqde3.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Since Tetsuo's patch already got merged, now this is the missing part
 > for local port reservation.
 > 
 > Cc: Roland Dreier <rdreier@cisco.com>
 > Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
 > Signed-off-by: WANG Cong <amwang@redhat.com>
 > 
 > ---
 > diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
 > index b930b81..7b89bab 100644
 > --- a/drivers/infiniband/core/cma.c
 > +++ b/drivers/infiniband/core/cma.c
 > @@ -1978,6 +1978,7 @@ static int cma_alloc_any_port(struct idr *ps, struct rdma_id_private *id_priv)
 >  	rover = net_random() % remaining + low;
 >  retry:
 >  	if (last_used_port != rover &&
 > +	    !inet_is_reserved_local_port(rover) &&
 >  	    !idr_find(ps, (unsigned short) rover)) {
 >  		int ret = cma_alloc_port(ps, id_priv, rover);
 >  		/*

Should this inet_is_reserved_local_port() test apply to all the "port
spaces" that this code is handling?  I honestly am ignorant of the
intended semantics of the new local_reserved_ports stuff, hence my question.

 - R.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
