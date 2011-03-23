Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab1CWPLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:11:34 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65138 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab1CWPLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:11:33 -0400
Date: Wed, 23 Mar 2011 11:11:26 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: andy.green@linaro.org, Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
In-Reply-To: <1300875732.2402.359.camel@pasglop>
Message-ID: <alpine.LFD.2.00.1103231056560.11889@xanadu.home>
References: <4D79F068.2080009@linaro.org> <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com> <1300828125.2402.300.camel@pasglop>  <4D8924B6.8040403@linaro.org> <1300842219.2402.309.camel@pasglop> <alpine.LFD.2.00.1103222138320.11889@xanadu.home>
 <1300850595.2402.320.camel@pasglop>  <4D89BDE2.60907@linaro.org> <1300875732.2402.359.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011, Benjamin Herrenschmidt wrote:

> Among ideas that have been proposed have been the idea of having stubs
> generating pseudo-device nodes from platform_data for devices in order
> to enable the drivers to use a single interface for example. That didn't
> really go through tho. However, whatever the final approach will be, the
> point remains that for drivers that have not so far been "contaminated"
> by the platform_data paradigm, we have the opportunity to try something
> better, which can then, maybe, be retro-fitted on a case by case basis
> to platform drivers, for example as such drivers get converted to also
> be capable of using the device-tree.
> 
> This is where I'm trying to propose a middle ground with the idea of
> named properties. It goes toward the direction that platform_device has
> been trying to to with the struct resource, but there's only so much you
> can do with these and they are showing their limits when it comes to
> expose arbitrary informations. MAC addresses are an example but there
> are many more, from clock bindings, power control, PHY data, connector
> informations, yadadada... which all can potentially apply to on-board
> USB or PCI based devices.

I think your middle ground proposal is more than that.  Conceptually, it 
positions DT as one of the possible device configuration backends 
instead of making DT the sanctioned configuration frontend.  To me this 
is very important as I don't want to be stuck with DT support where it 
would simply be an unwanted burden and overhead.  By having this generic 
abstraction in the middle, it is then possible to decouple DT from the 
actual drivers, and then use DT because it makes sense and not just 
because there is no way around it.  And who knows when some other non-DT 
configuration scheme may appear in the industry where the simple 
addition of another backend would make things more straight forward than 
having to construct synthetic FTDs on the fly.


Nicolas
