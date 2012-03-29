Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543Ab2C2PUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 11:20:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32858 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933520Ab2C2PUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 11:20:32 -0400
MIME-Version: 1.0
In-Reply-To: <4F68A46D.9020601@itdev.co.uk>
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
 <1331640263-18935-20-git-send-email-djkurtz@chromium.org> <4F68A46D.9020601@itdev.co.uk>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 29 Mar 2012 23:20:11 +0800
X-Google-Sender-Auth: 3w1vVZ9MIKRk3z-beMhKWMxsqP8
Message-ID: <CAGS+omBkqBqMC7f73RzXqdwkpqTOxUvWWYLMGefF+zdBKjKLTw@mail.gmail.com>
Subject: Re: [PATCH 19/20] Input: atmel_mxt_ts - remove mxt_make_highchg and
 parse T6 report
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>,
        "Tiwari, Atul" <Atul.Tiwari@atmel.com>,
        "Bowens, Alan" <Alan.Bowens@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 11:38 PM, Nick Dyer <nick.dyer@itdev.co.uk> wrote:
> Daniel Kurtz wrote:
>> This function attempts to make the CHG pin high by reading a bunch of
>> messages until the device is happy.  Instead of just blindly trying to
>> read a fixed number of messages, let's actually read and process them.
>>
>> It turns out that the messages after boot or nvupdates are T6 reports,
>> containing a status, and the config memory checksum.  So, let's parse
>> them and dump a useful info message.
>>
>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>
> mxt_make_highchg exists due to the interrupts being edge triggered. It
> forces the CHG line to go high.
>
> With this implementation, I suspect that if a new message arrives after you
> have read T44 and before you finish processing messages, then the interrupt
> handler will not ever be run. What testing have you done on this?

Actually, for the MXT224E on which I've been testing, the CHG line
goes high after reading the first byte of the T5 message (in other
words, the first byte of the first message, no matter how many
messages T44 reports).

Expect an updated version of this patchset soon.

Thanks for all of your reviews!

>
> The printout of T6 messages looks OK, though. I'd prefer to see a lookup
> table for the report IDs.
>
> --
> Nick Dyer
> Software Engineer, ITDev Ltd
> Hardware and Software Development Consultancy
> Website: http://www.itdev.co.uk
