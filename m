Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0K2BgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 20:36:18 -0500
Received: from rs35.luxsci.com ([66.216.127.90]:52040 "EHLO rs35.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab0K2BgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 20:36:17 -0500
Message-ID: <4CF30327.9020408@firmworks.com>
Date: Sun, 28 Nov 2010 15:34:31 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 03/11] x86/dtb: Add a device tree for CE4100
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>	 <1290706801-7323-4-git-send-email-bigeasy@linutronix.de>	 <1290808645.32570.158.camel@pasglop>  <20101128160449.GC30784@www.tglx.de> <1290984809.32570.208.camel@pasglop>
In-Reply-To: <1290984809.32570.208.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2010 12:53 PM, Benjamin Herrenschmidt wrote:
>> I wasn't aware of the OFW binding for X86. I will follow it once I find
>> it.
>
> Interesting, I though I would find it on
> http://www.openfirmware.info/Bindings but it's not there...
>
> CC'ing Mitch who might know where to find that.


I can't find the x86 binding either, which is a little bit embarrassing 
since I wrote it, albeit about 15 years ago...

If my memory is correct, it is not particularly useful now.  It 
primarily dealt with the ABI for transferring control to the OS and for 
calling back into the OFW client interface.  The only company that used 
it was Network Appliance, back when they were building their own x86 
motherboards (because most off-the-shelf mobo's of that era did not meet 
their stability requirements).

There has been a fair amount of churn since then, in relevant areas like 
x86 privileged architecture, compiler versions and code generation 
policies, popular bootloaders, OSs, and Linux early startup code.  The 
net result is that the ABI that the old binding specified probably isn't 
right for today.

I'd be happy to work with people to develop a new x86 binding.

The OLPC interface might be of some use as a starting point, but would 
need some work.  It is currently in use on AMD Geode, Via C7, and Intel 
Atom based systems, but, among other issues, it conflicts with the 
Physical Address Extension feature.

Mitch
