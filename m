Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab1DMDuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 23:50:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45906 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834Ab1DMDup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 23:50:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eDMj50jHedfcD0a3Hu8X6TUnNzmrTWp/1yupfX48u/uB8IwyW5C03K6tXEd5Sudg88
         2pNygqwesDSpHxkEtj+A15YVbaeJv/9eWTVZCxAPz4KkrOVXzsgqNB5YzF6HDNALHdmx
         9Hk3LqmCINecsksgLiNzPrWyZGNZ0RejRoiOk=
Date: Wed, 13 Apr 2011 12:50:37 +0900
From: "tj@kernel.org" <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>
Subject: Re: [PATCH 3/4]percpu_counter: fix code for 32bit systems
Message-ID: <20110413035037.GA24161@mtj.dyndns.org>
References: <1302595444.3981.129.camel@sli10-conroe>
 <1302599035.3233.27.camel@edumazet-laptop>
 <1302656465.3981.133.camel@sli10-conroe>
 <1302661927.2811.18.camel@edumazet-laptop>
 <1302662517.3981.161.camel@sli10-conroe>
 <1302662853.2811.41.camel@edumazet-laptop>
 <1302663781.3981.169.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302663781.3981.169.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

On Wed, Apr 13, 2011 at 11:03:01AM +0800, Shaohua Li wrote:
> I can do this, but please give a reason. If network code is the only
> place requiring disable irq, why not network code do it?

This thread is pointless.  The next patch converts it to atomic64_t
and the lock is removed anyway.  I think Eric's argument makes sense
given that atomic64_t translates into irqsave spinlock (it has to) in
generic 32bit implementation.  That said, this is all a moot point.
We might as well simply drop this patch and directly convert to
atomic64_t.

Thanks.

-- 
tejun
