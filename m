Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab0IOKU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:20:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39325 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab0IOKU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:20:28 -0400
Message-ID: <4C909D87.2090901@ru.mvista.com>
Date: Wed, 15 Sep 2010 14:18:47 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Sergei Shtylyov <sshtylyov@mvista.com>, balbi@ti.com,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RESEND/PATCH 5/6] USB: musb-gadget: complete request only if
 data is transfered over
References: <4C8E18AD.8000502@ru.mvista.com>	<AANLkTinei3u1OZ-eBiUTDF=PDjwxLcL6rBpt7iNQJgHJ@mail.gmail.com>	<4C8E4882.6040600@ru.mvista.com>	<4C8E50CC.3080705@ru.mvista.com>	<20100914065604.GD2601@legolas.emea.dhcp.ti.com>	<4C8F527E.40408@ru.mvista.com>	<20100914105402.GD7554@legolas.emea.dhcp.ti.com>	<4C8FB60D.1080906@ru.mvista.com>	<20100915065345.GC3393@legolas.emea.dhcp.ti.com>	<4C909961.10001@ru.mvista.com>	<20100915100553.GJ3393@legolas.emea.dhcp.ti.com>	<4C909B2E.3000909@ru.mvista.com> <AANLkTi=A+1ThrRTNjWoFbXr-G1OUnpThEwG5rCgGirzC@mail.gmail.com>
In-Reply-To: <AANLkTi=A+1ThrRTNjWoFbXr-G1OUnpThEwG5rCgGirzC@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 15-09-2010 14:14, Ming Lei wrote:

>>>> I didn't say it was duplicate for DMA, just too late.

>>> how come ? we need to send ZLP before giving back the request.

>>    Well, look at the code ionce again. We need to send ZLP *after*
>> request->actual == request->length, but as the check is inserted after the
>> ZLP send, ZLP *may* be sent once the first DMA completes, not the last.

> Yes, it is really a problem, as said by balbi.  And the problem should be
> in the check for zlp or the 'is_dma' condition.

> But this patch is not addressed for the zlp problem, and is is only for
> completing the request only if the data transfer in usb_request
> is over, as explained before, right?

    I don't see why we should fix only this problem, while it's obvious tha 
the fix is incomplete and leaves the other problem exposed. Please recast the 
patch.

WBR, Sergei
