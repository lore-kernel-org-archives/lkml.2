Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab0LOOcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:32:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37170 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab0LOOck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:32:40 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=wum_O5HyHpgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=-OHLZ1BGYllrnV2f6FkA:9 a=Q99TzAwn-VbtFG6fPnMA:7 a=Rre1yvDhwjnY6ApsnykD6s42tYcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] rtmutex: multiple candidate owners without unrelated
 boosting
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1012151515230.12146@localhost6.localdomain6>
References: <4D07330A.7020600@cn.fujitsu.com>
	 <1292379516.5015.1837.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1012150850380.12146@localhost6.localdomain6>
	 <1292421766.5015.1866.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1012151515230.12146@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 15 Dec 2010 09:32:37 -0500
Message-ID: <1292423557.5015.1868.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 15:16 +0100, Thomas Gleixner wrote:
> On Wed, 15 Dec 2010, Steven Rostedt wrote:
> 

> That does not matter. The interesting part is whether the lock on
> which orig_waiter is blocked on was unlocked. Lai's follow up patch does:
> 
> +       if (orig_waiter && !rt_mutex_owner(orig_lock))
>                 goto out_unlock_pi;
> 

I haven't looked at his new patch yet. But if this is the case, then we
can nuke all cand_* fields. This was the only reason I kept the
cand_owner in the first place.

Thanks,

-- Steve


