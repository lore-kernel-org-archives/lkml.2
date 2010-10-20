Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab0JTHyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 03:54:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57169 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab0JTHyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 03:54:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bYGR5fSVPKITototO0nN7E5Zvy6lw7jnMBypXXJJyqDkgj2qwIJpK3VVnuirIpt707
         se6jEP9eulioCglpSQ05DS/RNXMF55yliBFxPGgOq/QZwB+wxq9fCSCaNjKORBBI3gDH
         ZuIy/ki6GkORKeQiI5Nh4icr+p5tUeTiyRAjA=
Subject: Re: [PATCH 1/2]percpu: introduce read mostly percpu API
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <20101020073511.GC20124@basil.fritz.box>
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>
	 <1287551880.2700.79.camel@edumazet-laptop>
	 <20101020073511.GC20124@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 09:53:54 +0200
Message-ID: <1287561234.2328.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 20 octobre 2010 à 09:35 +0200, Andi Kleen a écrit :
> On Wed, Oct 20, 2010 at 07:18:00AM +0200, Eric Dumazet wrote:
> > Le mercredi 20 octobre 2010 à 11:07 +0800, Shaohua Li a écrit :
> > > Add a new readmostly percpu section and api, next patch will use it.
> > > 
> > > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > > ---
> > 
> > 
> > Could you precisely describe why grouping together read mostly percpu
> > variables is a win ? Especially when you add in your next patch a single
> > variable ?
> 
> Not Shaohua, but I can explain it:
> 
> There is some per cpu data which is read by other CPUs. In this 
> case it's a win to use the separate section because you avoid false sharing 
> and the cache line can be kept in shared mode on all CPUs.
> 
> The next patch has an example of such data: data which is read
> by another CPU to send something to the target CPU.
> 
> I think the concept is useful and makes a lot of sense.
> The alternative would be __read_mostly NR_CPUS arrays, but 
> we all know that is a bad idea because it wastes too much memory
> on CONFIG_MAX_SMP setups.
> 

My question was more a rethoric one. I understand for sure the intent.

All this should be explained in changelog, so that people know
when/where use this new class of per_cpu variables ;)

Thanks


