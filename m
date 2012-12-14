Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab2LNLp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:45:56 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:38693 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab2LNLpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:45:55 -0500
Message-ID: <50CB116D.7050701@openvz.org>
Date: Fri, 14 Dec 2012 15:45:49 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121123 Firefox/10.0.11 Iceape/2.7.11
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Jeff Garzik <jgarzik@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ata: uncomment ata_timing for XFER_PIO_SLOW
References: <20121214110137.9155.68183.stgit@zurg> <20121214111351.GA7307@liondog.tnic>
In-Reply-To: <20121214111351.GA7307@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Fri, Dec 14, 2012 at 03:01:37PM +0400, Konstantin Khlebnikov wrote:
>> This patch uncomments ata timings for XFER_PIO_SLOW,
>> otherwise ata_timing_find_mode() returns NULL and kernel crashes in
>> pacpi_set_dmamode() after null-pointer dereference.
>>
>> The same problem was mentioned recently in debug patch v3.7-rc5-72-gcd705d5
>> ("libata debugging: Warn when unable to find timing descriptor based on xfer_mode")
>>
>> I'm not sure about this patch, because I have no idea what this XFER_PIO_SLOW
>
> No, this is already fixed by:
>
>
> Btw, this patch will go to stable since I can't find it in 3.7, I'm
> guessing Jeff will send it to Linus soonish since it is in his NEXT
> branch.
>
> Until that happens, you could test 3.7 by cherrypicking the patch above
> ontop of it or by simply applying it by hand since it is only two lines.
>
> Or, you could wait and test -rc1 when it comes out after the world ends :-).

Ah, thanks. Sorry for noise. I'll check this again in current linux-next.

>
>> means and why this bug so rare (3 times during 4 days boot-reboot test) I caught
>> this on completely ordinary PC with nvidia MCP61 chipset, sata hdd and ide dvd-rom.
>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> Signed-off-by: Borislav Petkov<bp@alien8.de>
>> Signed-off-by: Jeff Garzik<jgarzik@redhat.com>
>
> Btw, just FYI, this is not how S-o-b chaining works. Take a look
> at<Documentation/SubmittingPatches>  for details on how it is done
> correctly.

ouch :facepalm: how I missed this... just copy-paste error. sorry again.

>
> HTH.
>

