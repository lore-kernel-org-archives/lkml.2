Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab0GLSgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 14:36:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65311 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab0GLSgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 14:36:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xALOSpXimbv7Ue84qyvx7V1JOjYwbR2X2dZrRjoTc7VGq6j1yq9TAW9d4b/m6OL0Rv
         pgi05tC6lFtLj/JzFpdSJi1GBVvzUC1lQmhiw8oo0mRAgeTg27chOEkSi+GBicZ1jtFm
         OquKS0vemS3GaVkJEEsAIdaybMRztVR2yrSk4=
Message-ID: <4C3B608B.9010501@lwfinger.net>
Date: Mon, 12 Jul 2010 13:35:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Possible false positive from checkpatch.pl
References: <4C3B5660.8020405@lwfinger.net> <1278959315.1501.261.camel@Joe-Laptop.home>
In-Reply-To: <1278959315.1501.261.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 01:28 PM, Joe Perches wrote:
> On Mon, 2010-07-12 at 12:52 -0500, Larry Finger wrote:
>> Andy,
>>
>> In preparing a vendor driver for submission to staging, I am getting the
>> following from checkpatch.pl:
>>
>> ERROR: Macros with multiple statements should be enclosed in a do - while loop
>> #377: FILE: staging/rtl8712/rtl871x_mp_ioctl.h:377:
>> +#define GEN_MP_IOCTL_HANDLER(sz, hdl, oid) {sz, hdl, oid},
>
> I think you should leave off the trailing comma from the macros
> and C99 might be better.  Maybe something like:
>
> (whatever the field names really are)
>
> #define GEN_MP_IOCTL_HANDLER(sz, hdl, oid)	\
> 	{.field1 = sz, .field2 = hdl, .field3 = oid}
>
>> ERROR: Macros with multiple statements should be enclosed in a do - while loop
>> #378: FILE: staging/rtl8712/rtl871x_mp_ioctl.h:378:
>> +#define EXT_MP_IOCTL_HANDLER(sz, subcode, oid) {sz,&mp_ioctl_ \
>> +       ## subcode ## _hdl, oid},
>
> The line continuation is rather ugly too.  Perhaps it's better as:
>
> #define EXT_MP_IOCTL_HANDLER(sz, subcode, oid)	\
> 	{.field1 = sz, .field2 =&mp_ioctl_##subcode##_hdl, .field3 = oid}
>
> They pass checkpatch without error.
>
> $ cat foo.h
> #define GEN_MP_IOCTL_HANDLER(sz, hdl, oid)	\
> 	{.field1 = sz, .field2 = hdl, .field3 = oid}
> #define EXT_MP_IOCTL_HANDLER(sz, subcode, oid)	\
> 	{.field1 = sz, .field2 =&mp_ioctl_##subcode##_hdl, .field3 = oid}
> $ ./scripts/checkpatch.pl -f foo.h
> total: 0 errors, 0 warnings, 4 lines checked
>
> foo.h has no obvious style problems and is ready for submission.

These are ugly macros that will be eliminated, but for the moment they are in 
the code. As I stated in my original email, removing the comma from the 
definition and adding it to the code does fix the checkpatch error, but it 
should not be necessary.

Larry
