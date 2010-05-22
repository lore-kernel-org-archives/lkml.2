Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0EVPP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 11:15:56 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:55789 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab0EVPPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 11:15:54 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,283,1272844800"; 
   d="scan'208";a="201219117"
From: Roland Dreier <rdreier@cisco.com>
To: wharms@bfs.de
Cc: Julia Lawall <julia@diku.dk>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 10/27] drivers/infiniband/core: Use memdup_user
References: <Pine.LNX.4.64.1005221021030.13021@ask.diku.dk>
	<4BF7A65D.1070501@bfs.de>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 22 May 2010 08:15:50 -0700
In-Reply-To: <4BF7A65D.1070501@bfs.de> (walter harms's message of "Sat, 22 May
	2010 11:39:41 +0200")
Message-ID: <adaaars0xy1.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > +	data = memdup_user((void __user *)(unsigned long)src, len);
 > > +	if (IS_ERR(data))
 > > +		return PTR_ERR(data);

 > This cast look strange, can it happen that (unsigned long)<(u64) ?
 > (is there a 32bit infiniband) ?

There is 32-bit infiniband.  Linux kernel assumes that unsigned long is
equivalent to uintptr_t -- in other words all pointers are the same size
as longs.  So when casting from integer to pointer we add a cast to
unsigned long to avoid a warning precisely in the 32-bit case -- we
would get a warning about cast to pointer from integer of different size
when casting from 64-bit integer to 32-bit pointer.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
