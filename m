Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab1JCRek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 13:34:40 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:44191 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab1JCRef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 13:34:35 -0400
Date: Mon, 3 Oct 2011 11:34:34 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
cc: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        "Taneja, Archit" <archit@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "R, Sricharan" <r.sricharan@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] OMAP2PLUS: DSS: Ensure DSS works correctly if display
 is enabled in bootloader
In-Reply-To: <4E898468.2060508@ti.com>
Message-ID: <alpine.DEB.2.00.1110031126090.4611@utopia.booyaka.com>
References: <1315811306-11001-1-git-send-email-archit@ti.com>  <alpine.DEB.2.00.1110022237171.4611@utopia.booyaka.com> <1317630070.2026.27.camel@deskari> <4E898468.2060508@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ devicetree-discuss, lkml

On Mon, 3 Oct 2011, Cousson, Benoit wrote:

> But at that time, device tree was not there...
> Now, the whole dev_attr stuff will be replaced because device tree is able to
> provide the driver any kind of custom information that can be retrieved
> directly from the driver without having to use a pdata in between. So I'm not
> sure it worth spending too much time on that feature stuff.
> 
> As an example here is the ongoing GPIO DT migration:
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg56505.html
> 
> 3.2 will have the basic DT support using hwmod as a backend, but the idea is
> that for 3.3, we start removing some information from hwmod to rely on device
> tree only.

One comment here though -- and I will make this comment on the original 
series too -- is that we should avoid adding direct DT dependencies into 
the driver.

Specifically, these of_get_property() and of_property*() calls in the 
driver aren't right.

We need some way of doing this that is completely independent from the 
device data format.  Some way that does not care whether the input data is 
coming from DT, platform_data, ACPI, or whatever the new flavor of the 
year will be next year.  Or we need to declare that these of_*() calls are 
not DT-specific, and define them as hooks that the device data format code 
can handle as it pleases.

Otherwise we'll need shim layers for each new data format in the driver 
code and that will be a huge and unnecessary mess.


- Paul
