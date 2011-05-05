Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab1EER5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 13:57:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59613 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab1EER5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 13:57:16 -0400
Date: Thu, 5 May 2011 19:57:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] time: Add locking to xtime access in get_seconds()
Message-ID: <20110505175713.GG2925@one.firstfloor.org>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org> <m2oc3jxgtt.fsf@firstfloor.org> <1304564090.2943.36.camel@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304564090.2943.36.camel@work-vm>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I suspect the reason this hasn't been triggered on x86 or power6 is due
> to compiler or processor optimizations reordering the assignment to in
> effect make it atomic. Or maybe the timing window to see the issue is
> harder to observe?

On x86 all aligned stores are atomic. So I don't see how this 
could be a problem ever.

Are you saying that on P6 only atomic stores are atomic?

If that's the case again I suspect other code will be affected
too.

-Andi
> 
