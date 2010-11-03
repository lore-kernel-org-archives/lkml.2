Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab0KCHZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 03:25:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61955 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab0KCHZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 03:25:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Lqh0Ph1Wbx4+F+wktdZ6W3V4AyBGBe4TMCFgOryUbcapA+322M13gVi2/C2ds/PZrW
         V3pDQcOiKIBY970xij0G+PXTG3INb+2lmg45RbPIt4/7W+A6aQgJR4KNNyTBzpFdMJo9
         pSH3S1zeZlxUZIrI7vklgRIv8jwFzsiZGn3kY=
Subject: Re: [RFC 4/4]x86: avoid tlbstate lock if no enough cpus
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <1288768795.23014.123.camel@sli10-conroe>
References: <1288766668.23014.117.camel@sli10-conroe>
	 <1288767580.2467.636.camel@edumazet-laptop>
	 <1288767995.23014.120.camel@sli10-conroe>
	 <1288768330.2467.660.camel@edumazet-laptop>
	 <1288768795.23014.123.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 08:25:23 +0100
Message-ID: <1288769123.2467.681.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 03 novembre 2010 à 15:19 +0800, Shaohua Li a écrit :
> On Wed, 2010-11-03 at 15:12 +0800, Eric Dumazet wrote:
> > Le mercredi 03 novembre 2010 à 15:06 +0800, Shaohua Li a écrit :
> > > just don't want to include the non-present cpus here. I wonder why we
> > > haven't a variable to record online cpu number.
> > 
> > What prevents a 256 cpus machine, to have 8 online cpus that all use the
> > same TLB vector ?
> > 
> > (Max 32 vectors, so 8 cpus share each vector, settled at boot time)
> > 
> > Forget about 'online', and think 'possible' ;)
> Hmm, the spread vectors to node already merged, how could the 8 cpus
> share a vector?
> 

You boot a machine with 256 cpu.

They are online and very well.

Each vector is shared by at least 8 cpus, because 256/32 = 8. OK ?

Now you off-line 256-8 cpus, because you have HOTPLUG capability in your
kernel and you have some policy to bring them up later if needed.

What happens ? Do you rebalance TLB vectors to make sure each cpu has
its own vector ?



