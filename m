Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab0KNQgm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 11:36:42 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55298 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab0KNQgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 11:36:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B91xSXgtNVdMF7YZEXYvfEF4YTcW0ot4Klk8tDLHTKViVI1tm1x6fkTJhjYbkgzQX0
         BWK4j4XedTHZiJofyJ4x7Ay8X0V28aKPLC4gnNocuJcQSnO+YE2c0swQxX2a47P2rYXM
         7BaO/NOA6Aj2DzzrXZ01z0kn9IBA7PsWMQai4=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=4U_kE6+V13=wJM+_7=iZW3NGew=jWcddDMO+m@mail.gmail.com>
References: <20101103181400.GA12818@core.coreip.homeip.net>
	<AANLkTi=4U_kE6+V13=wJM+_7=iZW3NGew=jWcddDMO+m@mail.gmail.com>
Date: Sun, 14 Nov 2010 17:36:39 +0100
Message-ID: <AANLkTin-K9jWjtM5qGPP_ZQXFJSAQFCQd9sG939nV033@mail.gmail.com>
Subject: Re: [PATCH] eeepc-wmi: fix compiler warning
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Chris Bagwell <chris@cnpbagwell.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 3, 2010 at 7:43 PM, Chris Bagwell <chris@cnpbagwell.com> wrote:
> On Wed, Nov 3, 2010 at 1:14 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>> This fixes the following:
>>
>>  CC [M]  drivers/platform/x86/eeepc-wmi.o
>> drivers/platform/x86/eeepc-wmi.c:322: warning: initialization from incompatible pointer type
>>
>> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
>> ---
>>
>>  drivers/platform/x86/eeepc-wmi.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>>
>> diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
>> index 462ceab..0d50fbb 100644
>> --- a/drivers/platform/x86/eeepc-wmi.c
>> +++ b/drivers/platform/x86/eeepc-wmi.c
>> @@ -298,8 +298,8 @@ static void eeepc_wmi_notify(u32 value, void *context)
>>        kfree(obj);
>>  }
>>
>> -static int store_cpufv(struct device *dev, struct device_attribute *attr,
>> -                      const char *buf, size_t count)
>> +static ssize_t store_cpufv(struct device *dev, struct device_attribute *attr,
>> +                          const char *buf, size_t count)
>>  {
>>        int value;
>>        struct acpi_buffer input = { (acpi_size)sizeof(value), &value };
>> --
>
> Opps.  Sorry, I missed that warning.  ssize_t is obviously correct return value.
>
> Reviewed-by: Chris Bagwell <chris@cnpbagwell.com>
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Just queued the same patch on my repo, I should have read the list first.

Matthew can you queue this one for next batch ?
Thanks,

-- 
Corentin Chary
http://xf.iksaif.net
