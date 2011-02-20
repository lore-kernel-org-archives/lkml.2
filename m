Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1BTUoJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 15:44:09 -0500
Received: from mail-ew0-f52.google.com ([209.85.215.52]:51944 "EHLO
	mail-ew0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1BTUoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 15:44:07 -0500
Message-ID: <4D617CC8.3020108@ru.mvista.com>
Date: Sun, 20 Feb 2011 23:42:48 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Sergei Shtylyov <sshtylyov@mvista.com>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/20] ata_piix: unify code for programming PIO and MWDMA
 timings
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>	<20110208122346.19110.8441.sendpatchset@linux-mhg7.site>	<4D6118DC.80505@ru.mvista.com> <20110220185958.364df4cc@lxorguk.ukuu.org.uk>
In-Reply-To: <20110220185958.364df4cc@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 20-02-2011 21:59, Alan Cox wrote:

>>> +	if (ata_pio_need_iordy(adev) || use_mwdma)
>>>    		control |= 2;	/* IE enable */

>>      Why IORDY is enabled for MWDMA has always been beyond me... I understand
>> that the stupid Intel docs are to be blamed here.

> I fail to see whats stupid about the docs ?

    Association of IORDY with DMA mode is wrong.

> The same timing register set is used for MWDMA and PIO cycles in MWDMA
> tuned modes (eg ATAPI). Thus the controller needs to be in an MWDMA mode
> whose timings are compatible with the PIO timing and we want IORDY in use
> for the PIO transfer parts.

    Yeah, especially if we also set the bit which only enables fast timing for 
DMA. ;-)
    PIO mode is setup by different code, and it takes care of the IORDY 
setting according to the PIO rules (and it gets called). DMA mode setup should 
just ignore the IORDY setting as in all other sane drivers.

> Alan

WBR, Sergei
