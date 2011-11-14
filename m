Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab1KNXiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:38:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45087 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab1KNXiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:38:14 -0500
Message-ID: <4EC1A65E.5040607@gmail.com>
Date: Tue, 15 Nov 2011 10:38:06 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Changli Gao <xiaosuo@gmail.com>, Ben Greear <greearb@candelatech.com>,
        Chetan Loke <loke.chetan@gmail.com>, waltje@uWalt.NL.Mugnet.ORG,
        gw4pts@gw4pts.ampr.org, waltje@linux.com, ross.biro@gmail.com,
        alan@linux.intel.com
Subject: Re: [PATCH] net/packet: remove dead code and unneeded variable from
 prb_setup_retire_blk_timer()
References: <alpine.LNX.2.00.1111132247440.3368@swampdragon.chaosbits.net> <4EC0AA31.9040403@gmail.com> <alpine.LNX.2.00.1111150034120.9919@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1111150034120.9919@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/11/11 10:37, Jesper Juhl wrote:

> On Mon, 14 Nov 2011, Ryan Mallon wrote:
> 
>> On 14/11/11 08:55, Jesper Juhl wrote:
>>
>>> We test for 'tx_ring' being != zero and BUG() if that's the case. So after
>>> that check there is no way that 'tx_ring' could be anything _but_ zero, so
>>> testing it again is just dead code. Once that dead code is removed, the
>>> 'pkc' local variable becomes entirely redundant, so remove that as well.
>>
>>
>> What if CONFIG_BUG=n?
>>
> 
> Arrgh, I didn't consider that (should have, but didn't).. In that case 
> we'll have 
> #define BUG() do {} while(0)
> which is not going to work all that peachy with my change...
> 
> David: You may want to pass on this one. I obviously didn't think it 
> through properly - sorry :-(
> 


It's something I've never been entirely clear on. How are you meant to
handle something which really is a fatal bug if CONFIG_BUG=n?

I think there are several places in the kernel where the expectation is
that BUG() causes a panic that probably don't behave nicely at all
(though I guess that might be the expected behaviour) if CONFIG_BUG=n.

~Ryan

