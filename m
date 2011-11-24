Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab1KXKsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:48:11 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:56361 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1KXKsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:48:09 -0500
Message-ID: <4ECE20C8.70400@atmel.com>
Date: Thu, 24 Nov 2011 11:47:36 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jamie Iles <jamie@jamieiles.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: manual merge of the at91 tree with the arm-soc tree
References: <20111124121611.fe102955910da2b603032d07@canb.auug.org.au> <20111124095603.GA5048@totoro>
In-Reply-To: <20111124095603.GA5048@totoro>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 10:56 AM, Jamie Iles :
> Hi Stephen,
> 
> On Thu, Nov 24, 2011 at 12:16:11PM +1100, Stephen Rothwell wrote:
>> Hi all,
>>
>> Today's linux-next merge of the at91 tree got conflicts in
>> arch/arm/mach-at91/board-cap9adk.c, arch/arm/mach-at91/board-cpu9krea.c,
>> arch/arm/mach-at91/board-cpuat91.c,
>> arch/arm/mach-at91/board-snapper9260.c and
>> arch/arm/mach-at91/include/mach/board.h between commit 84e0cdb0a262
>> ("macb: unify at91 and avr32 platform data") from the arm-soc tree and
>> commit 1509f4847dd1 ("at91/boards: use -EINVAL for invalid gpio") from
>> the at91 tree.
>>
>> I fixed them up (see below) and can carry the fix as necessary.
>>
>> However, it looks to me that struct macb_platform_data (in
>> include/linux/platform_data/macb.h) will need its phy_irq_pin members
>> changed to int as well (which may have other consequences).
> 
> That looks correct to me.  I've just posted a patch to convert 
> phy_irq_pin to an int and from inspection that shouldn't break anything 
> by itself.

Good, I will Acknowledge it.

> The macb driver doesn't currently use the phy_irq_pin member, but the 
> at91_ether driver does and that compares to 0 for no IRQ so the 
> assignment of -EINVAL _could_.

Yes indeed, I have a patch to address that and I send it now. However, I
guess that this will go on top of Jean-Christophe's gpio patch series.

Best regards,
-- 
Nicolas Ferre
