Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab0K2Tp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:45:28 -0500
Received: from www.tglx.de ([62.245.132.106]:38880 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab0K2Tp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:45:27 -0500
Message-ID: <4CF402AD.2060000@linutronix.de>
Date: Mon, 29 Nov 2010 20:44:45 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Mitch Bradley <wmb@firmworks.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [sodaville] [PATCH 03/11] x86/dtb: Add a device tree for CE4100
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>		<1290706801-7323-4-git-send-email-bigeasy@linutronix.de>		<1290808645.32570.158.camel@pasglop>	<20101128160449.GC30784@www.tglx.de>	<1290984809.32570.208.camel@pasglop> <4CF30327.9020408@firmworks.com>
In-Reply-To: <4CF30327.9020408@firmworks.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mitch Bradley wrote:
> On 11/28/2010 12:53 PM, Benjamin Herrenschmidt wrote:
>>> I wasn't aware of the OFW binding for X86. I will follow it once I find
>>> it.
>> Interesting, I though I would find it on
>> http://www.openfirmware.info/Bindings but it's not there...
>> CC'ing Mitch who might know where to find that.
> 
> I'd be happy to work with people to develop a new x86 binding.

So for the CPU node I have so far:

         cpus {
                  #address-cells = <1>;
                  #size-cells = <0>;

                  cpu@0 {
                          device_type = "cpu";
			 compatible = "Intel,CE4100";
                          reg = <0>;
                          lapic = <&lapic0>;
                  };
          };

This one should match ePARP 1.0. David mentioned threads. I have just one.
No HyperThreading, nothing special. Should I just leave it as it or go
for:
         cpus {
                  #address-cells = <1>;
                  #size-cells = <0>;

                  cpu@0 {
                          device_type = "cpu";
			 compatible = "Intel,CE4100";	
			 reg = <0>;
                	         lapic = <&lapic0>;

			thread@0 {
         	                 reg = <0>;
                  	};
		};
          };
?

Sebastian
