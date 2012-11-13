Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab2KMVyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:54:38 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64636 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab2KMVyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:54:37 -0500
MIME-Version: 1.0
In-Reply-To: <50A2BD87.3060202@tilera.com>
References: <1352840300-27814-1-git-send-email-simon.marchi@polymtl.ca> <50A2BD87.3060202@tilera.com>
From: Simon Marchi <simon.marchi@polymtl.ca>
Date: Tue, 13 Nov 2012 13:54:06 -0800
X-Google-Sender-Auth: QE3h813z3xatl7N8Yub9riAVuWI
Message-ID: <CAFXXi0kcGCqr-Ss5-Li9vXKCWyTh6Nvx+aAzVUZ1PZbZ=YZ2Pg@mail.gmail.com>
Subject: Re: [PATCH] tilegx: request_irq with a non-null device name
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 1:37 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> On 11/13/2012 3:58 PM, Simon Marchi wrote:
>> This patch simply makes the tilegx net driver call request_irq with a
>> non-null name. It makes the output in /proc/interrupts more obvious, but
>> also helps tools that don't expect to find null there.
>>
>> Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
>> ---
>>  drivers/net/ethernet/tile/tilegx.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
>> index 4e98100..66e025a 100644
>> --- a/drivers/net/ethernet/tile/tilegx.c
>> +++ b/drivers/net/ethernet/tile/tilegx.c
>> @@ -917,7 +917,7 @@ static int tile_net_setup_interrupts(struct net_device *dev)
>>       ingress_irq = rc;
>>       tile_irq_activate(ingress_irq, TILE_IRQ_PERCPU);
>>       rc = request_irq(ingress_irq, tile_net_handle_ingress_irq,
>> -                      0, NULL, NULL);
>> +                      0, "tile_net", NULL);
>
> Good catch.  If you can change it to dev->name instead of "tile_net", feel
> free to add my:

I thought about that first, but it wouldn't be very logical. This
module is loaded once and for all when the first network device is
brought up, so this request_irq is for all the tile network
interfaces. Suppose you "up" gbe0, "up" gbe1 and "down" gbe0, the
device name would still be gbe0, even though it's down. That's why I
opted for a generic name instead.

If you still want to go with dev->name I have no problem with that.

> Acked-by: Chris Metcalf <cmetcalf@tilera.com>
>
> --
> Chris Metcalf, Tilera Corp.
> http://www.tilera.com
>
