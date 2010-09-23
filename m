Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab0IWJM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 05:12:57 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47000 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab0IWJMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 05:12:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nmbugzIyNFCEpt8DVttTNDVjOmOwSPa5ALAHe1WXwu9Or7FHFVIPUSN16bnsB72Bas
         ZriEr8BEUMC4HmaHVCiR7DEgCQIm2kSonEFpC+FXTHMovtoJt2gzqBUYk4u6i9O7Oo0a
         0jGjO7wk1yco4GYHgqAzjclCMWCJaVOLnd+Gw=
MIME-Version: 1.0
In-Reply-To: <20100921124308.GC18991@one.firstfloor.org>
References: <1284865235-29920-1-git-send-email-ying.huang@intel.com>
	<1284865235-29920-4-git-send-email-ying.huang@intel.com>
	<20100921124308.GC18991@one.firstfloor.org>
Date: Thu, 23 Sep 2010 17:06:34 +0800
Message-ID: <AANLkTimrmFJE+7VQqRDe+3oj6XbsBTdfOn=B7Whj3dPS@mail.gmail.com>
Subject: Re: [PATCH 3/5] ACPI, APEI, HEST Fix the unsuitable usage of platform_data
From: huang ying <huang.ying.caritas@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andi,

On Tue, Sep 21, 2010 at 8:43 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Sun, Sep 19, 2010 at 11:00:33AM +0800, Huang Ying wrote:
>> diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
>> index 343168d..1a3508a 100644
>> --- a/drivers/acpi/apei/hest.c
>> +++ b/drivers/acpi/apei/hest.c
>> @@ -137,20 +137,23 @@ static int hest_parse_ghes_count(struct acpi_hest_header *hest_hdr, void *data)
>>
>>  static int hest_parse_ghes(struct acpi_hest_header *hest_hdr, void *data)
>
> hest_hdr is a local variable on the stack.
>
>
>> +
>> +     rc = platform_device_add_data(ghes_dev, &hest_hdr, sizeof(void *));
>> +     if (rc)
>> +             goto err;
>
> Now you put the address of that local variable in some global data structure.
>
> And then you likely return and later the access accesses random stack space?

platform_device_add_data will allocate some new memory, and copy
hest_hdr to there, so this is safe.

Best Regards,
Huang Ying
