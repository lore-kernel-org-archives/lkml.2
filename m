Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0JTHfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 03:35:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44844 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab0JTHfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 03:35:13 -0400
Date: Wed, 20 Oct 2010 09:35:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [PATCH 1/2]percpu: introduce read mostly percpu API
Message-ID: <20101020073511.GC20124@basil.fritz.box>
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>
 <1287551880.2700.79.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287551880.2700.79.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 07:18:00AM +0200, Eric Dumazet wrote:
> Le mercredi 20 octobre 2010 à 11:07 +0800, Shaohua Li a écrit :
> > Add a new readmostly percpu section and api, next patch will use it.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > ---
> 
> 
> Could you precisely describe why grouping together read mostly percpu
> variables is a win ? Especially when you add in your next patch a single
> variable ?

Not Shaohua, but I can explain it:

There is some per cpu data which is read by other CPUs. In this 
case it's a win to use the separate section because you avoid false sharing 
and the cache line can be kept in shared mode on all CPUs.

The next patch has an example of such data: data which is read
by another CPU to send something to the target CPU.

I think the concept is useful and makes a lot of sense.
The alternative would be __read_mostly NR_CPUS arrays, but 
we all know that is a bad idea because it wastes too much memory
on CONFIG_MAX_SMP setups.

-Andi

