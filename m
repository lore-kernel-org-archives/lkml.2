Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab0I0D5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 23:57:54 -0400
Received: from relay3.sgi.com ([192.48.152.1]:46861 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932640Ab0I0D5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 23:57:53 -0400
Date: Sun, 26 Sep 2010 20:57:51 -0700
From: Arthur Kepner <akepner@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [RFC/PATCHv2] kernel/irq: allow more precise irq affinity
	policies
Message-ID: <20100927035751.GI20474@sgi.com>
References: <20100922235208.GC19058@sgi.com> <alpine.LFD.2.00.1009230908080.2416@localhost6.localdomain6> <alpine.LFD.2.00.1009232015180.2416@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009232015180.2416@localhost6.localdomain6>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 08:36:35PM +0200, Thomas Gleixner wrote:
> 
> I thought more about this and came to the conclusion that this
> facility is completely overengineered and mostly useless except for a
> little detail.
> 
> The only problem which it solves is to prevent that we run out of
> vectors on the low numbered cpus when that NIC which insists to create
> one irq per cpu starts up.

Yep, that's the problem.

> 
> Fine, I can see that this is a problem, but we do not need this
> complete nightmare to solve it. We can do that way simpler.
> 
>  1) There is a patch from your coworker to work around that in the low
>     level x86 code, which is probably working, but suboptimal and not
>     generic
>

I don't know what you're referring to there.
 
>  2) We already know that the NIC requested the irq on node N. So when
>     we set it up, we just honour the wish of the driver as long as it
>     fits in the default (or modified) affinity mask and restrict the
>     affinity to the cpus on that very node.
> 
>     That makes a whole lot of sense: The driver already knows on which
>     cpus it wants to see the irq, because it allocated queues and
>     stuff there.
> 
>     So that's probably a 10 lines or less patch do fix that.
> ....

OK, the simple approach is fine with me. I'll send a patch in 
a minute.

-- 
Arthur
