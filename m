Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab1AHSQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 13:16:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64827 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab1AHSQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 13:16:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=CSo2Sc0wQJ/wuQANoB0di+JVPjWQvL6TTwJdoAyViSgP3sbPT7GjklIuUflrOUe1R9
         FNyxN1EOOF5DNK+akt5sgrE6nSHBTXMnC1RBkRjDCdRN87QplMNciTv3tcwEqiROTh9G
         rpY46NBw9RSm/eLl3tSPujahsTfbsZ+Lyjm0A=
Message-ID: <4D28A9EF.3050400@gmail.com>
Date: Sat, 08 Jan 2011 12:16:15 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: CPU Initiated DMA
References: <87mxncv3ge.fsf@inspiron.ap.columbia.edu>
In-Reply-To: <87mxncv3ge.fsf@inspiron.ap.columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2011 02:55 PM, Nikolaus Rath wrote:
> Hello,
>
> I want to write a driver for a rather dumb PCI card, which cannot become
> bus master itself. Is it possible to use a DMA controller on the
> mainboard to still transfer data to the card without occupying the CPU?
>
> (I believe this is the way DMA used to work on ISA cards, but do recent
> x86 systems still have a DMA controller for the CPU?)

The legacy ISA DMA controller worked like that, but you can't use that 
with PCI devices. Essentially there is no way to do this, barring 
perhaps some wierd platform specific feature.

This tends to be an issue with graphics card framebuffers in some cases. 
You may be able to use ioremap_wc to map your device's MMIO region as 
write-combining to reduce the amount of CPU overhead. However, note that 
this can result in writes to the device being reordered.

>
> Any pointers are greatly appreciated. I looked into "Linux Device
> Drivers", but the DMA chapter seems to be only about the device becoming
> busmaster.
>
>
>
> Best,
>
>     -Nikolaus
>

