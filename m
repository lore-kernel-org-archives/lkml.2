Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0KDFnC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 01:43:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39266 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab0KDFm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 01:42:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J2Nc41Zi04Lzc3wnfcjvxPySuxiqw5fHdD1bOTEFyZVwbmRNmpcCiOg6xYtDABE7J2
         PRvr4V5IuVLQALopEYajyfzPXxTCBA4GIzY4VZi0J/gHA3xXKNWbq85hTn3ct740HxWB
         PSVhLMrYvb9+tAeEk7DZW4Yr1PrWqjnJksmv8=
Subject: Re: [RFC 4/4]x86: avoid tlbstate lock if no enough cpus
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <1288848079.23014.131.camel@sli10-conroe>
References: <1288766668.23014.117.camel@sli10-conroe>
	 <1288767580.2467.636.camel@edumazet-laptop>
	 <1288767995.23014.120.camel@sli10-conroe>
	 <1288768330.2467.660.camel@edumazet-laptop>
	 <1288768795.23014.123.camel@sli10-conroe>
	 <1288769123.2467.681.camel@edumazet-laptop>
	 <1288769486.2467.690.camel@edumazet-laptop>
	 <1288773716.23014.124.camel@sli10-conroe>
	 <1288775282.2511.9.camel@edumazet-laptop>
	 <1288848079.23014.131.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 06:42:46 +0100
Message-ID: <1288849366.2718.42.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 04 novembre 2010 à 13:21 +0800, Shaohua Li a écrit :
> On Wed, 2010-11-03 at 17:08 +0800, Eric Dumazet wrote:
> > Le mercredi 03 novembre 2010 à 16:41 +0800, Shaohua Li a écrit :
> > 
> > > yes, this is ok. we might need avoid some cpu hotplug race too. I'll
> > > post a new patch later.
> > > 
> > > 
> > 
> > Hmm, maybe only set the variable "must take the lock", never unset it.
> I followed your suggestions to use nr_cpu_ids, it should be good enough.
> 

Yes, unfortunately not on HP machines, because of their tendency to have
holes in CPU numberings :)

This can probably can improved later.

Thanks

> Thanks,
> Shaohua
> 
> 
> This one isn't related to previous patch. If online cpus are below
> NUM_INVALIDATE_TLB_VECTORS, we don't need the lock. The comments
> in the code declares we don't need the check, but a hot lock still
> needs an atomic operation and expensive, so add the check here.
> 
> Uses nr_cpu_ids here as suggested by Eric Dumazet.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



