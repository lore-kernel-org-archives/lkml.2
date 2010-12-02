Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab0LBBfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 20:35:14 -0500
Received: from ozlabs.org ([203.10.76.45]:51050 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792Ab0LBBfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 20:35:13 -0500
Date: Thu, 2 Dec 2010 11:40:16 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mitch Bradley <wmb@firmworks.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [sodaville] [PATCH 03/11] x86/dtb: Add a device tree for CE4100
Message-ID: <20101202004016.GF3189@yookeroo>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Mitch Bradley <wmb@firmworks.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
	x86@kernel.org, linux-kernel@vger.kernel.org
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
 <1290706801-7323-4-git-send-email-bigeasy@linutronix.de>
 <1290808645.32570.158.camel@pasglop>
 <20101128160449.GC30784@www.tglx.de>
 <1290984809.32570.208.camel@pasglop>
 <4CF30327.9020408@firmworks.com>
 <4CF402AD.2060000@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF402AD.2060000@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 08:44:45PM +0100, Sebastian Andrzej Siewior wrote:
> Mitch Bradley wrote:
> >On 11/28/2010 12:53 PM, Benjamin Herrenschmidt wrote:
> >>>I wasn't aware of the OFW binding for X86. I will follow it once I find
> >>>it.
> >>Interesting, I though I would find it on
> >>http://www.openfirmware.info/Bindings but it's not there...
> >>CC'ing Mitch who might know where to find that.
> >
> >I'd be happy to work with people to develop a new x86 binding.
> 
> So for the CPU node I have so far:
> 
>         cpus {
>                  #address-cells = <1>;
>                  #size-cells = <0>;
> 
>                  cpu@0 {
>                          device_type = "cpu";
> 			 compatible = "Intel,CE4100";
>                          reg = <0>;
>                          lapic = <&lapic0>;
>                  };
>          };
> 
> This one should match ePARP 1.0. David mentioned threads. I have just one.
> No HyperThreading, nothing special. Should I just leave it as it or go
> for:
>         cpus {
>                  #address-cells = <1>;
>                  #size-cells = <0>;
> 
>                  cpu@0 {
>                          device_type = "cpu";
> 			 compatible = "Intel,CE4100";	
> 			 reg = <0>;
>                	         lapic = <&lapic0>;
> 
> 			thread@0 {
>         	                 reg = <0>;
>                  	};
> 		};
>          };
> ?

Leave it as is.  For hyperthreading there's a good chance you'll be
able to get away with the simple extension we're planning to use in
ePAPR 1.1, which would be:
	cpu@0 {
		...
		reg = <0 1 2 3>;
		...
	};

For, e.g. a cpu with 4 threads.

If more detailed per-thread information is needed then we or you might
want sub-nodes one day.  But even if we do that, we should allow them
to be omitted in the single-thread case.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
