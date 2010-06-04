Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0FDQE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 12:04:59 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:46745 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab0FDQE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 12:04:57 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAM7ACEyrR7Ht/2dsb2JhbACeRXGlOJoShRcEg0k
X-IronPort-AV: E=Sophos;i="4.53,362,1272844800"; 
   d="scan'208";a="139487118"
From: Roland Dreier <rdreier@cisco.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, davem@davemloft.net,
       linux-rdma@vger.kernel.org, sean.hefty@intel.com
Subject: Re: [Patch] infiniband: check local reserved ports
References: <20100603083106.6047.7657.sendpatchset@localhost.localdomain>
	<ada1vcoqde3.fsf@roland-alpha.cisco.com> <4C085C9A.30506@redhat.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 04 Jun 2010 09:04:53 -0700
In-Reply-To: <4C085C9A.30506@redhat.com> (Cong Wang's message of "Fri, 04 Jun
	2010 09:53:30 +0800")
Message-ID: <ada1vcmpyvu.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Should this inet_is_reserved_local_port() test apply to all the "port
 > > spaces" that this code is handling?  I honestly am ignorant of the
 > > intended semantics of the new local_reserved_ports stuff, hence my question.

 > Yes, but I only found this case, is there any else?

My question was more in the other direction: should this test apply to
all the "port spaces" handled here?  From looking at the code, it
appears the answer is yes -- it seems that putting a port in
local_reserved_ports reserves that port for IPv4 and IPv6, UDP, TCP,
SCTP, DCCP, everything, so we should probably reserve all RDMA CM ports too.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
