Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab1EDHsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 03:48:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62280 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab1EDHsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 03:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Bi5u6XAaDsYILINi4hC2BguA9hKern5Z9oqmttxDvwJeFyLHKHoKFuLGYY+RMFuKxF
         ZnTxZWGnu65aM9v4Yc5GXk18WC8EQ8zNzxJdSqhNWGPFY8XGjwTAgPtWIJ3g484tnUMj
         E/EyHVPv27G3vwfsmYZspmFteX9YzuwzoVVZA=
MIME-Version: 1.0
In-Reply-To: <430965.32751.qm@web29011.mail.ird.yahoo.com>
References: <1304421107.15687.15.camel@flow>
	<430965.32751.qm@web29011.mail.ird.yahoo.com>
Date: Wed, 4 May 2011 09:48:13 +0200
Message-ID: <BANLkTimjDV+--w6LM9F3tbtvLvqW=e-sTw@mail.gmail.com>
Subject: Re: [PATCH 2/2] leds: Add ASIC3 LED support
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 10:25 PM, Paul Parsons <lost.distance@yahoo.com> wrote:
> Hi Philipp,
>
> --- On Tue, 3/5/11, Philipp Zabel <philipp.zabel@gmail.com> wrote:
>
>> About this, see the other patch I sent. This should work
>> with the GPIOs
>> configured as outputs.
> See my response on the other thread.

Will do.

>> Could be moved into struct resource definitions in
>> asic3.c.
>> Get to them with platform_get_resource() in
>> asic3_led_probe().
>> After calculating the bus shift from the resource size, you
>> have
>> everything you need to get rid of the
>> asic3_write_register() export.
> I understand, but my feeling is that implementing a more generic mechanism will add complexity for little obvious gain. If the LED driver ever needs to be more generic then this can be revisited.

Fair enough. Looks like your feeling is right - de-inlining and
exporting asic3_read/write_register costs only ~300 bytes. iomem
resources + ioremap + bus shift calculation in leds-asic3.o are
probably bigger than that.

regards
Philipp
