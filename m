Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1BULyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 06:54:50 -0500
Received: from mail-ew0-f42.google.com ([209.85.215.42]:62011 "EHLO
	mail-ew0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab1BULys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 06:54:48 -0500
Message-ID: <4D625238.6040503@mvista.com>
Date: Mon, 21 Feb 2011 14:53:28 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/20] ata_piix: unify code for programming PIO and MWDMA
 timings
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>	<20110208122346.19110.8441.sendpatchset@linux-mhg7.site>	<4D6118DC.80505@ru.mvista.com>	<20110220185958.364df4cc@lxorguk.ukuu.org.uk>	<4D617CC8.3020108@ru.mvista.com> <20110220210731.0c774fa7@lxorguk.ukuu.org.uk> <4D624EBD.4080400@ru.mvista.com>
In-Reply-To: <4D624EBD.4080400@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-02-2011 14:38, Sergei Shtylyov wrote:

>>> PIO mode is setup by different code, and it takes care of the IORDY
>>> setting according to the PIO rules (and it gets called). DMA mode setup should
>>> just ignore the IORDY setting as in all other sane drivers.

>> Well it can't ignore it - but if you mean just keep the bit as is then

> Yes, I mean this.

>> that sounds sensible, have to see what the docs say happens if you ever
>> set MWDMA without IORDY.

> Don't think they say anything on this matter but I can't imagine that IORDY
> matters for DMA.

    What it says is that IORDY enable bit has no effect when the fast timing 
bit is cleared. That's from ICH IDE PRM (29860004.pdf).

WBR, Sergei
