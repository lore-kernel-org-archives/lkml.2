Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab0IOLC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:02:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44503 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0IOLCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:02:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TCoTMJt4aHPRSO3flgK5zVhKqhSzQJIYIIrPZc42s1FgtB+iU7KHD5hqXjayaZAd12
         q8Prbba+3gmrHbA3LS7gbl8DIKT+yJsuAoVOxOPoCArDDSvO0FVu7+sJFri5RDNmQdab
         yinW8ShC5J7b6HjCH7UnuKJIHtO6uamfnkj2A=
MIME-Version: 1.0
In-Reply-To: <20100915105641.GO3393@legolas.emea.dhcp.ti.com>
References: <AANLkTinPVUBNJoOR496KgSy2TT0f6i1f5xEKVhKod2R=@mail.gmail.com>
	<20100915105641.GO3393@legolas.emea.dhcp.ti.com>
Date: Wed, 15 Sep 2010 19:02:22 +0800
Message-ID: <AANLkTi=gYSsxSHqAur+isj_UinVLC-YWkdmi5j_vkSUV@mail.gmail.com>
Subject: Re: [Discussion] USB: musb-gadget: how to fix ZLP issue in musb_g_tx
From: Ming Lei <tom.leiming@gmail.com>
To: balbi@ti.com
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, "greg@kroah.com" <greg@kroah.com>,
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

2010/9/15 Felipe Balbi <balbi@ti.com>:
> Hi,
>
> On Wed, Sep 15, 2010 at 05:53:10AM -0500, Ming Lei wrote:
>>
>> 1),  why is the check for "is_dma" needed here?
>>
>>     if (is_dma || request->actual == request->length) {
>>          ....
>>     }
>
> if you programmed dma to request->length (and assuming it worked just
> fine) mode1 will only interrupt you when the entire request has been
> sent.

If so, once the dma interrupt comes, will request->actual be same
with request->length in musb_g_tx?  And if it is true, could we remove the
check for 'is_dma'?

>
>> 2), why is a zlp needed in the case below?
>>
>>     #ifdef CONFIG_USB_INVENTRA_DMA
>>                 || (is_dma && (!dma->desired_mode ||
>>                    (request->actual & (musb_ep->packet_sz - 1))))
>>    #endif
>
> in that case, it's not a zlp, it's short packet. Inventra will *NOT*
> transfer short packets, you need to set txpktrdy by hand to get it
> transfered.

I see now.

>
>> IMO, it is not difficult to give a good fix for the ZLP problem
>> if the two questions are clear.
>
> true, but some re-work needs to be done.

Thanks for your reply.


-- 
Lei Ming
