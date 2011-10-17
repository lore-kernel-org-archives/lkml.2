Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab1JQTVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 15:21:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61093 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1JQTVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 15:21:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=jZ5B+/o/M7vm9wZGOw1twIC7ElEvakXDXhFUfse14uzgvki0Djwinw1Jl338W6zct
	Hcek36heJlnWqmkRRO8ow==
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1110171710570.3541@pobox.suse.cz>
References: <1318637934-30006-1-git-send-email-tlambert@chromium.org>
	<alpine.LNX.2.00.1110171710570.3541@pobox.suse.cz>
Date: Mon, 17 Oct 2011 12:21:16 -0700
X-Google-Sender-Auth: _TMXw8OUjiT0oL4Rqwwut9Z-BoE
Message-ID: <CAA_E9NH0EznO9xc7L=5GuqbZyFSWQU1J1HWzAYbuP5YTFzuXaw@mail.gmail.com>
Subject: Re: [PATCH] Driver for Primax keyboards violating USB HID spec
From: Terry Lambert <tlambert@chromium.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cool, thanks! I was mildly unsure of that anyway, and had copied it
from a similar one for the Microsoft HID driver.

-- Terry

On Mon, Oct 17, 2011 at 8:11 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Fri, 14 Oct 2011, Terry Lambert wrote:
>
>> Primax keyboards with the issue this driver addresses report modifier
>> keys as in band key events instead of as out of band modifier bits,
>> resulting in the modifier keys generating key up events immediately
>> before the keys they are intended to modify.  This driver rewrites
>> the raw report data from such keyboards into USB HID 1.11 compliant
>> report data.  It only matches the USB vendor and product IDs for the
>> keyboard it has been tested on. Since there are several keyboards,
>> notably a number of laptops and folding USB keyboards known to have
>> similar unresolved problem reports, the list is expected to grow.
>>
>> Signed-off-by: Terry Lambert <tlambert@chromium.org>
>> ---
>>  drivers/hid/Kconfig      |    8 +++
>>  drivers/hid/Makefile     |    1 +
>>  drivers/hid/hid-core.c   |    1 +
>>  drivers/hid/hid-ids.h    |    3 +
>>  drivers/hid/hid-primax.c |  117 ++++++++++++++++++++++++++++++++++++++++++++++
>>  5 files changed, 130 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/hid/hid-primax.c
>>
>> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
>> index 1130a89..a097e17 100644
>> --- a/drivers/hid/Kconfig
>> +++ b/drivers/hid/Kconfig
>> @@ -441,6 +441,14 @@ config HID_PICOLCD_LEDS
>>       ---help---
>>         Provide access to PicoLCD's GPO pins via leds class.
>>
>> +config HID_PRIMAX
>> +     tristate "Primax non-fully HID-compliant devices" if EXPERT
>> +     depends on USB_HID
>> +     default !EXPERT
>
> I have removed thi 'EXPERT' dependency (please see changelog of commit
> 73d5e8f77e8 for rationale behind that) and applied. Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
>
