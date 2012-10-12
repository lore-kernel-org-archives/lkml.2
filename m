Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849Ab2JLRBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:01:09 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55040 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab2JLRBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:01:06 -0400
Message-ID: <50784CCC.3050300@gmail.com>
Date: Fri, 12 Oct 2012 12:01:00 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jonathan@jonmasters.org, eric.dumazet@gmail.com,
        Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: Re: [PATCH 5/6] net: calxedaxgmac: rework transmit ring handling
References: <1350054908-30646-1-git-send-email-robherring2@gmail.com>  <1350054908-30646-6-git-send-email-robherring2@gmail.com> <1350059332.2819.18.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1350059332.2819.18.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 11:28 AM, Ben Hutchings wrote:
> On Fri, 2012-10-12 at 10:15 -0500, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Only generate tx interrupts on every ring size / 4 descriptors. Move the
>> netif_stop_queue call to the end of the xmit function rather than
>> checking at the beginning.
> [...]
> 
> The hardware should also interrupt if the TX ring becomes empty; does it
> do that?

Yes, with the "tx buffer unavailable" bit DMA_INTR_ENA_TUE. It is not a
per descriptor interrupt.

However, I just noticed I missed part of this patch to actually enable
tx descriptor interrupt. New version coming.

Rob
