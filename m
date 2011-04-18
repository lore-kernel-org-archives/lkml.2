Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1DRObI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:31:08 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63155 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab1DRObE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:31:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tORujJSmNybCdsDl1vrxbzNH2Mx6G72Ef0pHWYFs50WgCIHkPR4zFLKzRcVCB8/2fa
         VO5+VeOkWSIujJPgGsqpu/HgXc1neAQb94Nsu2cmNTmNiY4Z4le1FVl88Gz99E6B/yXM
         X1qdaGF5lF3HzHLzK5IjM954pFCSS9QQX67yk=
MIME-Version: 1.0
In-Reply-To: <201104181619.35115.arnd@arndb.de>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
	<201104171938.12834.arnd@arndb.de>
	<BANLkTim6iCAsViJQS4XrY-XObs8pp-BiQQ@mail.gmail.com>
	<201104181619.35115.arnd@arndb.de>
Date: Mon, 18 Apr 2011 16:31:02 +0200
Message-ID: <BANLkTinB-9h=bZg9zg219i2wi3zUCA6mcw@mail.gmail.com>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: George Kashperko <george@znau.edu.ua>, Hauke Mehrtens <hauke@hauke-m.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arend van Spriel <arend@broadcom.com>,
        Jonas Gorski <jonas.gorski@gmail.com>, b43-dev@lists.infradead.org,
        Greg KH <greg@kroah.com>, Andy Botting <andy@andybotting.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 18 kwietnia 2011 16:19 użytkownik Arnd Bergmann <arnd@arndb.de> napisał:
> On Monday 18 April 2011, Rafał Miłecki wrote:
>> W dniu 17 kwietnia 2011 19:38 użytkownik Arnd Bergmann <arnd@arndb.de> napisał:
>>
>> > In general, the bus_type directly relates to how a device gets probed.
>> > If broadcom uses the same basic register layout as regular AMBA devices,
>> > it should use the amba bus type.
>>
>> From Broadcom side we *could* use some registers that are AMBA
>> specific, they are present... but there is totally no point in doing
>> that. Everything we use is Broadcom specific.
>>
>>
>> > I think it would be fine to extend the AMBA bus slightly if there are
>> > just minor differences.
>>
>> As I said, Broadcom specific driver use nothing from AMBA common
>> things. Plus we implement routines that are Broadcom specific and no
>> other platform will use them.
>
> You mean the hardware has two sets of registers containing the same
> information, one of them the standard registers, and one with broadcom
> specific ones?
>
> Why don't you just use the standard ones then?

No. Did you read my first mail in this thread?

There is pair of cores for every device. First is AMBA-specific called
agent/wrapper and second one is Broadcom-specific.

AMBA specific core called agent/wrapper has AMBA specific registers:
CID and PID. However we do not ever read that in Broadcom driver,
because that are useless for us. On AMBA specific core we use only
some Broadcom specific registers to manage (enable/disable) *second*
(Broadcom-specific) core.

-- 
Rafał
