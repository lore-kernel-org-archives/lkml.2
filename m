Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab1DMEhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 00:37:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:40021 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab1DMEhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 00:37:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,202,1301900400"; 
   d="scan'208";a="908859134"
Subject: Re: [PATCH 3/4]percpu_counter: fix code for 32bit systems
From: Shaohua Li <shaohua.li@intel.com>
To: "tj@kernel.org" <tj@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>
In-Reply-To: <20110413035037.GA24161@mtj.dyndns.org>
References: <1302595444.3981.129.camel@sli10-conroe>
	 <1302599035.3233.27.camel@edumazet-laptop>
	 <1302656465.3981.133.camel@sli10-conroe>
	 <1302661927.2811.18.camel@edumazet-laptop>
	 <1302662517.3981.161.camel@sli10-conroe>
	 <1302662853.2811.41.camel@edumazet-laptop>
	 <1302663781.3981.169.camel@sli10-conroe>
	 <20110413035037.GA24161@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 12:37:08 +0800
Message-ID: <1302669428.3981.172.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 11:50 +0800, tj@kernel.org wrote:
> Hello, guys.
> 
> On Wed, Apr 13, 2011 at 11:03:01AM +0800, Shaohua Li wrote:
> > I can do this, but please give a reason. If network code is the only
> > place requiring disable irq, why not network code do it?
> 
> This thread is pointless.  The next patch converts it to atomic64_t
> and the lock is removed anyway.  I think Eric's argument makes sense
> given that atomic64_t translates into irqsave spinlock (it has to) in
> generic 32bit implementation.  That said, this is all a moot point.
> We might as well simply drop this patch and directly convert to
> atomic64_t.
We need it for UP case anyway. Ok, I'll change it to irqsave in next
post.

Thanks,
Shaohua

