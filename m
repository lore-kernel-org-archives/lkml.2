Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab1CWKgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:36:42 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56229 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1CWKgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:36:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z3AzhTqesK/sqZxm8aPLWkocQZRXzk/jGs8C84kR99x2qIbnsTYgPhzigicVIxop2v
         PRl29DHgpB4ASJJOZB6aw7oi9YFLaYNnEORpIfCSVhO/IKq2Inl/HZtWEb3nvdpvkzJc
         0Pw9DAo8NsdqRyU6+cFQlJiwq9UkemWd7fd3c=
MIME-Version: 1.0
In-Reply-To: <4D89CB04.70003@gmail.com>
References: <1300864088-24438-1-git-send-email-marek.belisko@open-nandra.com>
	<4D89CB04.70003@gmail.com>
Date: Wed, 23 Mar 2011 11:36:41 +0100
Message-ID: <AANLkTikoZmbkNAw2uD-AAbNMrgyrd2kGt9APBLCioMQf@mail.gmail.com>
Subject: Re: [PATCH] staging: ft1000-pcmcia: Fix ft1000_dnld() to work also on
 64bit architectures.
From: Belisko Marek <marek.belisko@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org,
        Stano Lanci <chl.pixo@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 11:27 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 03/23/2011 08:08 AM, Marek Belisko wrote:
>> From: pixo <pixo@pixo-LIFEBOOK-E8310.(none)>
>>
>> Firmware file needs to be read by 4bytes also on 64 bit architectures.
>> Change long type to u32 and also extend checking. Tested on 32 and also
>> 64 bit architectures.
>>
>> Signed-off-by: Stano Lanci <chl.pixo@gmail.com>
>> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
>>
>> Tested-by: Stano Lanci <chl.pixo@gmail.com>
>> ---
>>  drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |   78 ++++++++++----------
>>  1 files changed, 39 insertions(+), 39 deletions(-)
>>
>> diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
>> index b0729fc..fb375ea 100644
>> --- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
>> +++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
>> @@ -95,47 +95,47 @@ void put_request_value(struct net_device *dev, long lvalue);
>>  USHORT hdr_checksum(PPSEUDO_HDR pHdr);
>>
>>  typedef struct _DSP_FILE_HDR {
>> -     long build_date;
>> -     long dsp_coff_date;
>> -     long loader_code_address;
>> -     long loader_code_size;
>> -     long loader_code_end;
>> -     long dsp_code_address;
>> -     long dsp_code_size;
>> -     long dsp_code_end;
>> -     long reserved[8];
>> +     u32  build_date;
>> +     u32  dsp_coff_date;
>> +     u32  loader_code_address;
>> +     u32  loader_code_size;
>> +     u32  loader_code_end;
>> +     u32  dsp_code_address;
>> +     u32  dsp_code_size;
>> +     u32  dsp_code_end;
>> +     u32  reserved[8];
>>  } __attribute__ ((packed)) DSP_FILE_HDR, *PDSP_FILE_HDR;
>
> As you also changed signedness, did you check (or do you know) that the
> values cannot be negative?
No structures represent FW part and non of values could be negative.
This is bug from old implementation.
>
> Or at least the change doesn't affect code flow?
>
> regards,
> --
> js
>

regards,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
