Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab2CNWc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:32:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932403Ab2CNWcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:32:54 -0400
Message-ID: <4F611C8F.4030100@redhat.com>
Date: Wed, 14 Mar 2012 19:32:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile_edac: Fix the memory controller ID
References: <1331560917-14071-1-git-send-email-mchehab@redhat.com> <4F60ED44.70808@tilera.com>
In-Reply-To: <4F60ED44.70808@tilera.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 14-03-2012 16:11, Chris Metcalf escreveu:
> On 3/12/2012 10:02 AM, Mauro Carvalho Chehab wrote:
>> Fix a regression introduced by changeset 7b03829a8ba4:
>>
>> -       mci = edac_mc_alloc(sizeof(struct tile_edac_priv),
>> -               TILE_EDAC_NR_CSROWS, TILE_EDAC_NR_CHANS, pdev->id);
>> +       mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false,
>> +                           sizeof(struct tile_edac_priv));
>>
>> The pdev->id is missing.
>>
>> Compile-tested only. Btw, in order to compile it, I had to:
>>
>> 1) comment a header at arch/tile/include/asm/linkage.h:
>>
>> 	-#include <feedback.h>
>> 	+//#include <feedback.h>
>>
>> 2) Use the ./arch/tile/configs/tilegx_defconfig . the tilepro_defconfig
>>    is broken;
>>
>> 3) manually enable the EDAC module on it.
>>
>> Somebody has to fix it ;)
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> You might amend the commit message based on our conversation, but otherwise:
> 
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>
> 
> Thanks for fixing up the tile EDAC driver, BTW :-)

Thanks for the ack!

Btw, I've introduced the bug, on this changeset:
	http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commit;h=3b6909be050f03366322b0d5b45d38eedee77574

So, it is my moral duty to fix it ;)

Btw, I'd appreciate if you could test the EDAC driver on tile after that
series. It makes the edac core more flexible to represent the location of
the broken memory on the way the memory controller works, in order to
put its fingers at the Field Repleaceable Unit (FRU) - like a DIMM stick.
It should be easy (and it probably makes sense on embedded hardware) to
add there a way to report each DRAM memory is broken.

The entire series is at:
	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git hw_events_v7

Thank you!
Mauro

Thanks,
Mauro
> 

