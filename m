Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0IWPfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:35:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62647 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab0IWPfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=YwHos8FEB/408JGrVo5Q0PvLyAcsCVvc+SiZoaeHviI/tAf+yHR5zeKscISYeX7eJR
         nbDh9JtSfeyPXOl9lT6DFBY8HdxxrThj528qiopmi+lR7okhyzSVD/WBw0ZAafMkR5bW
         sKuBCnUXAqVoD3VAEBQP00gMaJMAoUUE0HK90=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=7gsXT2P-7a=DCTsaUBK=B131VFFCBzNVzpYFv@mail.gmail.com>
References: <1283256734-3408-1-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-2-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-3-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-4-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-5-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-6-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-7-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-8-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-9-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-10-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-11-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-12-git-send-email-linus.walleij@stericsson.com>
	<AANLkTimGu1R0vqpLK9X30CxkibO6N964D1Y-fQvAdA9D@mail.gmail.com>
	<AANLkTi=7gsXT2P-7a=DCTsaUBK=B131VFFCBzNVzpYFv@mail.gmail.com>
Date: Thu, 23 Sep 2010 08:35:13 -0700
X-Google-Sender-Auth: -OjWoszvvuSbIhxiHu4xMXI2zWs
Message-ID: <AANLkTik0Qy9nbWcreL3oOYg-KKhZ793i6tvfCmwiLgc=@mail.gmail.com>
Subject: Re: [PATCH 11/12] DMAENGINE: let PL08X memcpy TXDs wait
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, yuanyabin1978@sina.com,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Per_Frid=E9n?= <per.friden@stericsson.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 12:46 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/9/23 Dan Williams <dan.j.williams@intel.com>:
>
>> The prep routine is meant to guarantee that all the resources for a
>> transaction have been acquired.
>
> A practicality here:
>
> The assumption to fail for physical channel allocation at .tx_submit()
> is already in the first patch adding the driver.
>
> Should I squash all the icremental improvements into the original
> driver, convert to fail at .prep() and resubmit to make all of this
> easier, or do you want me to refactor the patch stack, or refactor
> from patch 11/12 or...?
>

At this point I am already rebasing my next branch to catch up with
the backlog, so a new v5 of the driver with all the roll-ups works for
me.

Also not sure if you caught this comment from earlier:
> sidenote: this driver needs to be converted to a dma descriptor pool
> (allocated at device_alloc_chan_resources time), or at a minimum use
> GFP_NOWAIT in device_prep_dma_memcpy because that routine may be
> called from atomic contexts.

Thanks,
Dan
