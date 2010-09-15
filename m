Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab0IOKCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:02:49 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57256 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab0IOKCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:02:47 -0400
Message-ID: <4C909961.10001@ru.mvista.com>
Date: Wed, 15 Sep 2010 14:01:05 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: balbi@ti.com
CC: Sergei Shtylyov <sshtylyov@mvista.com>, Ming Lei <tom.leiming@gmail.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RESEND/PATCH 5/6] USB: musb-gadget: complete request only if
 data is transfered over
References: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com> <1283873014-32511-6-git-send-email-tom.leiming@gmail.com> <4C8E18AD.8000502@ru.mvista.com> <AANLkTinei3u1OZ-eBiUTDF=PDjwxLcL6rBpt7iNQJgHJ@mail.gmail.com> <4C8E4882.6040600@ru.mvista.com> <4C8E50CC.3080705@ru.mvista.com> <20100914065604.GD2601@legolas.emea.dhcp.ti.com> <4C8F527E.40408@ru.mvista.com> <20100914105402.GD7554@legolas.emea.dhcp.ti.com> <4C8FB60D.1080906@ru.mvista.com> <20100915065345.GC3393@legolas.emea.dhcp.ti.com>
In-Reply-To: <20100915065345.GC3393@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 15-09-2010 10:53, Felipe Balbi wrote:

>>>> If a DMA interrupt comes when the whole transfer is not yet
>>>> complete (and
>>>> other Ming Lei's patches are making this possible),

>> Oh, here I mixed some other patch with Ming Lei's ones...

>>>> it will pass due to the

>>> than this is the actual problem, no ? If we're using mode1 dma (as we
>>> are on tx path), we should only get dma interrupt when the whole
>>> transfer has been completed.

>> The Inventra DMA controller has serious DMA length limitation, so the whole
>> transfer may take more than one DMA.

> When I said 'whole transfer' I meant the transfer size you programmed
> dma to transfer, see that we have (not actual code):

> if (transfer_size > dma->max_len)
> transfer_size = dma->max_len;

> dma->channel_program(...,..., transfer_size,...);

    Ah, I didn't mean the same thing -- I meant the transfer size as specified 
by 'struct usb_request'.

> with mode1, we will only get irq when dma has transferred transfer_size
> bytes.

    Sure.

>>> likewise, this was there before the patch. I don't think the real
>>> problem lies with this patch, it's been there for a while, don't you
>>> agree ?

>> Then what problem this patch fixes, if not this one?

> if request->length == 1MB and dma->max_len = 128KB, when is_dma is true,
> request->actual will be different from request->length for 7
> 'iterations', then only on the 8th it will be the same. I believe that's
> what Ming is trying to fix.

    I repeat once again: it's too late to check this where Ming is inserting 
the check.

> Ming, am I correct ?
>
>> Let me repeat: in the PIO mode the added check is just duplicate, in the DMA

> it is duplicate for PIO, but not for DMA.

    I didn't say it was duplicate for DMA, just too late.

WBR, Sergei
