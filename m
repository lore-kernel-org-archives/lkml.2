Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab0GNQka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 12:40:30 -0400
Received: from gandalf.light-speed.de ([85.214.152.96]:60020 "EHLO
	mail.light-speed.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab0GNQk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 12:40:29 -0400
Message-ID: <4C3DE870.4020503@letzte-bankreihe.de>
Date: Wed, 14 Jul 2010 18:40:16 +0200
From: Stephan Wolf <stephan@letzte-bankreihe.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100628 Thunderbird/3.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] enable readback to get HPET working on ATI SB4x00, kernel
 	2.6.35_rc5
References: <4C3DDDFF.5040302@letzte-bankreihe.de> <AANLkTim5fAwwhqP2J9pfOqeJACFf0OvK_MMZc1oZb3M4@mail.gmail.com>
In-Reply-To: <AANLkTim5fAwwhqP2J9pfOqeJACFf0OvK_MMZc1oZb3M4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Am 14.07.2010 18:13, schrieb Linus Torvalds:
> On Wed, Jul 14, 2010 at 8:55 AM, Stephan Wolf
> <stephan@letzte-bankreihe.de>  wrote:
>>   After commit 30a564be9d9554c168a654eddc2165869cc0d7bf "x86, hpet: Restrict
>> read back to affected ATI chipsets" hpet did not work anymore on HP nx6325.
>> The machine hangs on booting until a keystroke was taken. After a short time
>> machine hangs again until next keystroke. Applying the following patch
>> solves the issue for me.
> Ok, this makes sense. Bugs in the ATI chipset is why
> 'hpet_readback_cmp' exists in the first place. HOWEVER, clearly that
> commit changed it to be about too few ATI chipsets.
>
> So right now, for
>
>   - PCI_DEVICE_ID_ATI_SBX00_SMBUS:
>       force disable HPET MSI
>       force HPET readback
>
>   - PCI_DEVICE_ID_ATI_IXP400_SMBU
>       force-enable HPET
>       ...and than your patch makes it force HPET readback
>
> but that doesn't actually make much sense in the bigger picture,
> because there are other ATI chipsets that are related and presumably
> also affected. What about IXP[23]00_SMBUS? And what about the IXP7
> series (SBX00 is IXP6, afaik)?
>
> So I get the feeling that this is incomplete, or at least needs
> thinking about those other ATI chipsets too.
>
> Thomas? And I added Andreas to the cc, maybe he knows what's up.
>
>                          Linus
>
Ok, I did not consider that msi is disabled at all on IXP400. Isn't it? 
Maybe that the reason why it is works for me.

Stephan
