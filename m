Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab1GDOl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:41:59 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:7053 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab1GDOl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:41:57 -0400
Message-ID: <4E11D123.9070409@atmel.com>
Date: Mon, 04 Jul 2011 16:41:39 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, patrice.vilchez@atmel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for 3.0] AT91: Change nand buswidth logic to match hardware
 default configuration
References: <1309515924-22531-1-git-send-email-nicolas.ferre@atmel.com> <4E1189BD.509@atmel.com> <201107041625.25972.arnd@arndb.de>
In-Reply-To: <201107041625.25972.arnd@arndb.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 04/07/2011 16:25, Arnd Bergmann :
> On Monday 04 July 2011, Nicolas Ferre wrote:
>> Le 01/07/2011 12:25, Nicolas Ferre :
>>> The recently modified nand buswitth configuration is not aligned with
>>> board reality: the double footprint on boards is always populated with 8bits
>>> buswidth nand flashes.
>>> So we have to consider that without particular configuration the 8bits
>>> buswidth is selected by default.
>>> Moreover, the previous logic was always using !board_have_nand_8bit(), we
>>> change it to a simpler: board_have_nand_16bit().
>>>
>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>> Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
>>
>> Arnd,
>>
>> Can you please handle this parch for 3.0-final as a bug fix through the
>> arm-soc.git tree?
>>
>> You can queue it in addition of the pull request sent by
>> Jean-Christophe: "AT91: Fix pull requset".
> 
> Ok, I've integrated it in the branch and will send the pull request.
> 
> My preference would be to see fixes this late in the cycle more
> minmal. This patch does two things: 1. change the polarity of the
> system_rev bit as a bug fix and 2. change the polarity of the
> function reading it as a cleanup. Both changes look absolutely
> ok, but it's better to do the cleanup for the next kernel.
> 
> In this case, studying the patch more closely shows that it's
> very harmless, but I'd rather not have to look that closely.

Well, in fact it is a fix against what was introduced in a 3.0 patch
which I found to be wrong.
The reason because I do not want to be in next kernel is the fact that
it can puzzle the user (people that want to use kernel without changing
the system_rev between 2.6.39 -> 3.0 and again revert their changes for
3.0 -> 3.1).

> Am I correct that the bug is a regression against 2.6.39?

No, in fact it was introduced during 3.0 early -rc.

Anyway, thanks a lot Arnd.
Best regards,
-- 
Nicolas Ferre

