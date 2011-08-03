Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1HCNxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:53:16 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40202 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1HCNxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:53:11 -0400
MIME-Version: 1.0
In-Reply-To: <20110803133138.GO11080@legolas.emea.dhcp.ti.com>
References: <1312299219-9562-1-git-send-email-per.forlin@stericsson.com>
	<20110803133138.GO11080@legolas.emea.dhcp.ti.com>
Date: Wed, 3 Aug 2011 15:53:10 +0200
Message-ID: <CAJ0pr183rzgoaVStgb=8Umxy3tKheTVE4vJia4qjCdwTjKmA-A@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: ux500: set dma config for both src and dst
From: Per Forlin <per.forlin@linaro.org>
To: balbi@ti.com
Cc: Per Forlin <per.forlin@stericsson.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        users@igloocommunity.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 August 2011 15:31, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Aug 02, 2011 at 05:33:39PM +0200, Per Forlin wrote:
>> From: Per Forlin <per.forlin@linaro.org>
>>
>> The dma driver requires both src and dst to be set.
>> This fix is needed in order to run gadget mass storage.
>> Patch is verified on snowball.
>>
>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>
> should this go for stable too ??
>
Short answer no.

Reason:
I ran into this bug when applying upcoming dma driver patches. Adding
this patch now will makes sure the musb driver works when the dma
driver is updated..
Up until now the dma driver only use the peripheral end point
configuration and set it for both src and dst. Upcoming patches (not
sure if they are submitted yet) will allow src and dst to be different
therefore the client must set both.


> --
> balbi
>
