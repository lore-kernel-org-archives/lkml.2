Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab1CWDXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:23:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:53446 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab1CWDXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:23:46 -0400
Subject: Re: RFC: Platform data for onboard USB assets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: andy.green@linaro.org, Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca
In-Reply-To: <alpine.LFD.2.00.1103222138320.11889@xanadu.home>
References: <4D79F068.2080009@linaro.org>
	 <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>
	 <1300828125.2402.300.camel@pasglop>  <4D8924B6.8040403@linaro.org>
	 <1300842219.2402.309.camel@pasglop>
	 <alpine.LFD.2.00.1103222138320.11889@xanadu.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 14:23:15 +1100
Message-ID: <1300850595.2402.320.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Sorry Ben, but you are the one who sounds like a priest here, having 
> invoked the "religious" qualifier twice in a row in this thread.

Time to burn a few books then :-)

> I think that Andy is asking absurdly good questions which are backed by 
> candid logic and reasoning.  If anything, his arguments are purely 
> technical and extremely practical. And so far all he's got for answers 
> was rather subjective, emotionally charged and even dogmatic.

I think the technical aspects have been essentially answered. The
important part of the thread is what the "right" approach to identifying
the on-board device (vs. an equivalent device being hot-plugged), and I
think we all agreed this has to be the physical port "path" (in case
there's hubs or switches on the way).

The device-tree and whatever other udev based solutions using physical
path are both "transports" in a sense for that same information and so
in the grand scheme of thing equivalent.

The argument boils down to should we encourage adding an additional
in-kernel platform_data based hooks for dynamically probed busses such
as USB as well ? or go for a udev based solution for the time being
which would probably work as well in practice and focus on getting the
device-tree based solution for the long term instead.

> With regards to DT on ARM I'm rather "softly" convinced this is a good 
> thing.  However seeing a persisting lack of truly technical answers to 
> Andy's questions is rather disturbing, and makes me wish for much more 
> than the current hype around DT which appears to fall flat when 
> challenged.

I don't think any technical answer is missing. Dynamic platform data is
possible and in fact the platform could do it today using bus notifiers
and "hooking up" the platform data on the fly if needed I suppose.

Does it make sense however to add platform data for generic probed
devices ? I don't think so.

For some reason Andy doesn't seem to consider the lack of type
information as a problem, Grant and I do, I don't know where we can go
from there, it's a very technical argument and I don't feel like I need
to teach people on this list what are the drawbacks on relying on void *
pointers to structures attached to devices like that that -will- go
wrong.

I simply believe that this is the wrong solution for the problem. I
would very much prefer having a way for the driver to retrieve "platform
attributes".

This is essentially what the name/value properties of the device-tree
provide, but it could be abstracted in a way that doesn't require the
device-tree and allows drivers to be unchanged whether the thing is
backed with a DT or by platform callbacks as long as there's a minimum
amount of thought given to naming the property reasonably.

For some reason I didn't find Andy answers conductive to a reasonable
discussion and indeed I admit I probably switched to dismiss/troll mode
a bit too quickly, so let's the heat go down a bit here and see if we
can find a common ground.

If you guys can agree on my above proposal, we could maybe come up with
some "get_device_attribute(dev, name)" kind of interface, that would
then boild down to platform calls or device-tree transparently (or arch
calls optionally populated by generic device-tree based helpers
etc....).

This would be much better I believe that having those random structures
hooked up to void * pointers floating around and also generally more
flexible vs. platforms that provide or don't provide some of this
information (platforms might provide a subset etc...)

> There is one hard fact that no one can ignore: DT support on ARM still 
> has a long way to go before it is truly usable.  The world just can't 
> stop turning until this is ready.

Right but more efforts could be put into making that happen :-)

Cheers
Ben.

> 
> Nicolas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


