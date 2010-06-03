Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431Ab0FCJYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:24:15 -0400
Received: from smtp.nokia.com ([192.100.122.230]:44764 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab0FCJYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:24:13 -0400
Message-ID: <4C0774A8.2030704@nokia.com>
Date: Thu, 03 Jun 2010 12:23:52 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/2] mmc: split mmc_sd_init_card()
References: <1-1000-12432-1274803827-7569@rere.qmqm.pl> <20100528144027.3c868841.akpm@linux-foundation.org> <20100531155846.GA9493@rere.qmqm.pl>
In-Reply-To: <20100531155846.GA9493@rere.qmqm.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Jun 2010 09:23:52.0774 (UTC) FILETIME=[7B895E60:01CB02FE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha³ Miros³aw wrote:
> Thanks for your review!
> 
> On Fri, May 28, 2010 at 02:40:27PM -0700, Andrew Morton wrote:
>> On Tue, 25 May 2010 18:10:28 +0200 (CEST)
>> Micha__ Miros__aw <mirq-linux@rere.qmqm.pl> wrote:
>>> This is needed to avoid code duplication in SD-combo support.
>> hm.  Perhaps you could have told us a bit more about it than this.
>>> +int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid)
>>> +int mmc_sd_get_csd(struct mmc_host *host, struct mmc_card *card)
>>> +int mmc_sd_setup_card(struct mmc_host *host, struct mmc_card *card,
>>> +unsigned mmc_sd_get_max_clock(struct mmc_card *card)
>>> +void mmc_sd_go_highspeed(struct mmc_card *card)
>> These are global symbols, but they are not exported to (other) modules.
>> That's odd.  I'd have expected to see them either `static' or
>> EXPORT_MODULE()d.
> 
> This is all contained in mmc_core.ko and needs not be exported to other
> modules. A SD-combo card is a SD (memory) and SDIO in one package - the
> only changes needed are in initialization sequence, after which both
> parts are mostly independent.

That is a bit vague.  An SD card is a memory.  An SDIO "card" is an
I/O connection made using the same physical interface as an SD card
and a very similar protocal to SD cards (at least with respect to
reading and writing).  I do not understand how a card can be SD and
SDIO.  Are you sure you are not talking about a controller that supports
SD and SDIO?  A lot of controllers do that.

> 
>> I'll take the lack of a signed-off-by: and the "RFC" as signal to not
>> apply these patches.
> 
> I would like for this to get tested by other people first, but it looks
> like not many kernel developers use SD combo cards.
> 
> I'll resend the patches after applying your suggestions from the other
> mail.
> 
> Best Regards,
> Micha³ Miros³aw
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

