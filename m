Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1FGW5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:57:17 -0400
Received: from stinky.trash.net ([213.144.137.162]:63095 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab1FGW5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:57:15 -0400
Message-ID: <4DEEACC3.3030509@trash.net>
Date: Wed, 08 Jun 2011 00:57:07 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Brad Campbell <brad@fnarfbargle.com>,
        Bart De Schuymer <bdschuym@pandora.be>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: KVM induced panic on 2.6.38[2367] & 2.6.39
References: <20110601011527.GN19505@random.random>	 <alpine.LSU.2.00.1105312120530.22808@sister.anvils>	 <4DE5DCA8.7070704@fnarfbargle.com> <4DE5E29E.7080009@redhat.com>	 <4DE60669.9050606@fnarfbargle.com> <4DE60918.3010008@redhat.com>	 <4DE60940.1070107@redhat.com> <4DE61A2B.7000008@fnarfbargle.com>	 <20110601111841.GB3956@zip.com.au> <4DE62801.9080804@fnarfbargle.com>	 <20110601230342.GC3956@zip.com.au> <4DE8E3ED.7080004@fnarfbargle.com>	 <isavsg$3or$1@dough.gmane.org> <4DE906C0.6060901@fnarfbargle.com>	 <4DED344D.7000005@pandora.be> <4DED9C23.2030408@fnarfbargle.com>	 <4DEE27DE.7060004@trash.net> <4DEE3859.6070808@fnarfbargle.com>	 <4DEE4538.1020404@trash.net> <1307471484.3091.43.camel@edumazet-laptop>
In-Reply-To: <1307471484.3091.43.camel@edumazet-laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.06.2011 20:31, Eric Dumazet wrote:
> Le mardi 07 juin 2011 à 17:35 +0200, Patrick McHardy a écrit :
> 
>> The main suspects would be NAT and TCPMSS. Did you also try whether
>> the crash occurs with only one of these these rules?
>>
>>> I've just compiled out CONFIG_BRIDGE_NETFILTER and can no longer access
>>> the address the way I was doing it, so that's a no-go for me.
>>
>> That's really weird since you're apparently not using any bridge
>> netfilter features. It shouldn't have any effect besides changing
>> at which point ip_tables is invoked. How are your network devices
>> configured (specifically any bridges)?
> 
> Something in the kernel does 
> 
> u16 *ptr = addr (given by kmalloc())
> 
> ptr[-1] = 0;
> 
> Could be an off-one error in a memmove()/memcopy() or loop...
> 
> I cant see a network issue here.

So far me neither, but netfilter appears to trigger the bug.

> I checked arch/x86/lib/memmove_64.S and it seems fine.

I was thinking it might be a missing skb_make_writable() combined
with vhost_net specifics in the netfilter code (TCPMSS and NAT are
both suspect), but was unable to find something. I also went
through the dst_metrics() conversion to see whether anything could
cause problems with the bridge fake_rttable, but also nothing
so far.
