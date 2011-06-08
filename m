Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab1FHASS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 20:18:18 -0400
Received: from fnarfbargle.com ([93.93.131.224]:37806 "EHLO fnarfbargle.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753614Ab1FHASQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 20:18:16 -0400
Message-ID: <4DEEBFC2.4060102@fnarfbargle.com>
Date: Wed, 08 Jun 2011 08:18:10 +0800
From: Brad Campbell <brad@fnarfbargle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Bart De Schuymer <bdschuym@pandora.be>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: KVM induced panic on 2.6.38[2367] & 2.6.39
References: <20110601011527.GN19505@random.random>	 <alpine.LSU.2.00.1105312120530.22808@sister.anvils>	 <4DE5DCA8.7070704@fnarfbargle.com> <4DE5E29E.7080009@redhat.com>	 <4DE60669.9050606@fnarfbargle.com> <4DE60918.3010008@redhat.com>	 <4DE60940.1070107@redhat.com> <4DE61A2B.7000008@fnarfbargle.com>	 <20110601111841.GB3956@zip.com.au> <4DE62801.9080804@fnarfbargle.com>	 <20110601230342.GC3956@zip.com.au> <4DE8E3ED.7080004@fnarfbargle.com>	 <isavsg$3or$1@dough.gmane.org> <4DE906C0.6060901@fnarfbargle.com>	 <4DED344D.7000005@pandora.be> <4DED9C23.2030408@fnarfbargle.com>	 <4DEE27DE.7060004@trash.net> <4DEE3859.6070808@fnarfbargle.com>	 <4DEE4538.1020404@trash.net> <1307471484.3091.43.camel@edumazet-laptop> <4DEEACC3.3030509@trash.net>
In-Reply-To: <4DEEACC3.3030509@trash.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/11 06:57, Patrick McHardy wrote:
> On 07.06.2011 20:31, Eric Dumazet wrote:
>> Le mardi 07 juin 2011 à 17:35 +0200, Patrick McHardy a écrit :
>>
>>> The main suspects would be NAT and TCPMSS. Did you also try whether
>>> the crash occurs with only one of these these rules?
>>>
>>>> I've just compiled out CONFIG_BRIDGE_NETFILTER and can no longer access
>>>> the address the way I was doing it, so that's a no-go for me.
>>>
>>> That's really weird since you're apparently not using any bridge
>>> netfilter features. It shouldn't have any effect besides changing
>>> at which point ip_tables is invoked. How are your network devices
>>> configured (specifically any bridges)?
>>
>> Something in the kernel does
>>
>> u16 *ptr = addr (given by kmalloc())
>>
>> ptr[-1] = 0;
>>
>> Could be an off-one error in a memmove()/memcopy() or loop...
>>
>> I cant see a network issue here.
>
> So far me neither, but netfilter appears to trigger the bug.

Would it help if I tried some older kernels? This issue only surfaced 
for me recently as I only installed the VM's in question about 12 weeks 
ago and have only just started really using them in anger. I could try 
reproducing it on progressively older kernels to see if I can find one 
that works and then bisect from there.
