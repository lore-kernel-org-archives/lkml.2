Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab0IOKOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:14:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35382 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0IOKOy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:14:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FQEjyBFAl+7wFGzEldN8fqC3+4FyF4C+jNuyznyZIm+7BvEfKORe51IqCrQZ5GNPUa
         eKPDpoiao7SkhuxM8RXIRXH2GD0MKBeZuQ47WOg+hiS5lVjUfz7JXmKdeMx4chh+t3fA
         s5GGzbYOAddXTjvZiEFi6EsPCuI9GKArNiW0U=
MIME-Version: 1.0
In-Reply-To: <4C909B2E.3000909@ru.mvista.com>
References: <4C8E18AD.8000502@ru.mvista.com>
	<AANLkTinei3u1OZ-eBiUTDF=PDjwxLcL6rBpt7iNQJgHJ@mail.gmail.com>
	<4C8E4882.6040600@ru.mvista.com>
	<4C8E50CC.3080705@ru.mvista.com>
	<20100914065604.GD2601@legolas.emea.dhcp.ti.com>
	<4C8F527E.40408@ru.mvista.com>
	<20100914105402.GD7554@legolas.emea.dhcp.ti.com>
	<4C8FB60D.1080906@ru.mvista.com>
	<20100915065345.GC3393@legolas.emea.dhcp.ti.com>
	<4C909961.10001@ru.mvista.com>
	<20100915100553.GJ3393@legolas.emea.dhcp.ti.com>
	<4C909B2E.3000909@ru.mvista.com>
Date: Wed, 15 Sep 2010 18:14:51 +0800
Message-ID: <AANLkTi=A+1ThrRTNjWoFbXr-G1OUnpThEwG5rCgGirzC@mail.gmail.com>
Subject: Re: [RESEND/PATCH 5/6] USB: musb-gadget: complete request only if
 data is transfered over
From: Ming Lei <tom.leiming@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: balbi@ti.com, "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/15 Sergei Shtylyov <sshtylyov@mvista.com>:
> Hello.
>
> On 15-09-2010 14:05, Felipe Balbi wrote:
>
>>> I didn't say it was duplicate for DMA, just too late.
>
>> how come ? we need to send ZLP before giving back the request.
>
>   Well, look at the code ionce again. We need to send ZLP *after*
> request->actual == request->length, but as the check is inserted after the
> ZLP send, ZLP *may* be sent once the first DMA completes, not the last.

Yes, it is really a problem, as said by balbi.  And the problem should be
in the check for zlp or the 'is_dma' condition.

But this patch is not addressed for the zlp problem, and is is only for
completing the request only if the data transfer in usb_request
is over, as explained before, right?

-- 
Lei Ming
