Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab1CWFp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 01:45:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:55148 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab1CWFp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 01:45:26 -0400
Subject: Re: RFC: Platform data for onboard USB assets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: andy.green@linaro.org, Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca
In-Reply-To: <alpine.LFD.2.00.1103222336030.11889@xanadu.home>
References: <4D79F068.2080009@linaro.org>
	 <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>
	 <1300828125.2402.300.camel@pasglop>  <4D8924B6.8040403@linaro.org>
	 <1300842219.2402.309.camel@pasglop>
	 <alpine.LFD.2.00.1103222138320.11889@xanadu.home>
	 <1300850595.2402.320.camel@pasglop>
	 <alpine.LFD.2.00.1103222336030.11889@xanadu.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 16:44:55 +1100
Message-ID: <1300859095.2402.339.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-23 at 00:21 -0400, Nicolas Pitre wrote:
> 
> I wholeheartedly agree with that idea.  One thing that bothers me about DT 
> is its tendency to show up deep into the guts of kernel code all over 
> the place.  If a generic abstraction can be put in place, such as this 
> get_device_attribute() example, then it is far more convenient to use 
> DT, or _eventually_ use DT, or even _not_ use it in some cases but 
> something else, without battling over the actual interface 

I've always tried to take the approach on powerpc when designing an
important feature such as the virtual IRQ remapping, to make the
device-tree use a "useful add-on" without making it entirely necessary.

To continue on that example, the low level irq_domain (irq_host but
being renamed) only carries the OF pointer as a "token" (I think at some
point I even had it a void *), and the low level APIs for establishing
the mapping between a domain/hw_irq and virq don't rely on any
device-tree bits at all.

However, helpers built on top of that (along with one "translation"
callback in the irq domain itself) provide the device-tree integration
which makes the whole thing a lot easier to use.

But we still use the low level bits in some areas, old machines with 
broken DT, hard wired interrupt numbers coming from firmware, etc...

Cheers,
Ben.


