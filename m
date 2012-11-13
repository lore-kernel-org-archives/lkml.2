Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2KMV7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:59:45 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:60664 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2KMV7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:59:43 -0500
Message-ID: <50A2C2CD.9090308@tilera.com>
Date: Tue, 13 Nov 2012 16:59:41 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Simon Marchi <simon.marchi@polymtl.ca>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tilegx: request_irq with a non-null device name
References: <1352840300-27814-1-git-send-email-simon.marchi@polymtl.ca> <50A2BD87.3060202@tilera.com> <CAFXXi0kcGCqr-Ss5-Li9vXKCWyTh6Nvx+aAzVUZ1PZbZ=YZ2Pg@mail.gmail.com>
In-Reply-To: <CAFXXi0kcGCqr-Ss5-Li9vXKCWyTh6Nvx+aAzVUZ1PZbZ=YZ2Pg@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 4:54 PM, Simon Marchi wrote:
> On Tue, Nov 13, 2012 at 1:37 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>> On 11/13/2012 3:58 PM, Simon Marchi wrote:
>>> This patch simply makes the tilegx net driver call request_irq with a
>>> non-null name. It makes the output in /proc/interrupts more obvious, but
>>> also helps tools that don't expect to find null there.
>>>
>>> Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
>>> ---
>>>  drivers/net/ethernet/tile/tilegx.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
>>> index 4e98100..66e025a 100644
>>> --- a/drivers/net/ethernet/tile/tilegx.c
>>> +++ b/drivers/net/ethernet/tile/tilegx.c
>>> @@ -917,7 +917,7 @@ static int tile_net_setup_interrupts(struct net_device *dev)
>>>       ingress_irq = rc;
>>>       tile_irq_activate(ingress_irq, TILE_IRQ_PERCPU);
>>>       rc = request_irq(ingress_irq, tile_net_handle_ingress_irq,
>>> -                      0, NULL, NULL);
>>> +                      0, "tile_net", NULL);
>> Good catch.  If you can change it to dev->name instead of "tile_net", feel
>> free to add my:
> I thought about that first, but it wouldn't be very logical. This
> module is loaded once and for all when the first network device is
> brought up, so this request_irq is for all the tile network
> interfaces. Suppose you "up" gbe0, "up" gbe1 and "down" gbe0, the
> device name would still be gbe0, even though it's down. That's why I
> opted for a generic name instead.
>
> If you still want to go with dev->name I have no problem with that.

No, you're right, that's a good point.  It does probably make more sense to
use "tile_net".  So apply my Acked-by to your patch as-is.  Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

