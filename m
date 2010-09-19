Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab0ISSj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 14:39:57 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44195 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab0ISSj4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 14:39:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JPrbVhNdSUeqdXOT/2pKGxJjTgsF3P6j+xkRbSsX34mD8eCve6qpmsOjB3ZjbpsOVu
         FY2jw68FcK+vA+P/OSyXy5bA4+/teSyFehJEJiqetLZUEiueL0QLeh4/HTgVhALmikCK
         J6NrAhZgdEnXby9+ws+7ob/UcLQtQVEQybYaA=
MIME-Version: 1.0
In-Reply-To: <20100918115043.GB2953@joi.lan>
References: <1284764006.13604.21.camel@morgan.silverblock.net>
	<20100918115043.GB2953@joi.lan>
Date: Sun, 19 Sep 2010 20:39:55 +0200
Message-ID: <AANLkTimVNDwD61TgRDCnL--gu6QV7VVQsK8UqchryUdk@mail.gmail.com>
Subject: Re: [PATCH] drm/edid: Don't repeatedly log hex dumps of bad EDIDs by default
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/18 Marcin Slusarz <marcin.slusarz@gmail.com>:
> On Fri, Sep 17, 2010 at 06:53:26PM -0400, Andy Walls wrote:
>> On my system, every 10 seconds drm_edid_block_valid() gets called 4
>> times by radeon_dvi_detect().  This results in 4 instances of a
>> multi-line hex dump of the same EDID (non-)data being logged every 10
>> seconds.
>>
>> Silence the hex dump from drm_edid_block_valid() unless a drm_debug
>> module parameter flag is set.
>>
>> Signed-of-by: Andy Walls <awalls@md.metrocast.net>
>>
>> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
>> index dce5c4a..33a748c 100644
>> --- a/drivers/gpu/drm/drm_edid.c
>> +++ b/drivers/gpu/drm/drm_edid.c
>> @@ -173,9 +173,12 @@ drm_edid_block_valid(u8 *raw_edid)
>>
>>  bad:
>>         if (raw_edid) {
>> -               DRM_ERROR("Raw EDID:\n");
>> -               print_hex_dump_bytes(KERN_ERR, DUMP_PREFIX_NONE, raw_edid, EDID_LENGTH);
>> -               printk("\n");
>> +               DRM_DEBUG("Raw EDID:\n");
>> +               if (drm_debug & DRM_UT_CORE) {
>> +                       print_hex_dump_bytes(KERN_ERR, DUMP_PREFIX_NONE,
>> +                                            raw_edid, EDID_LENGTH);
>> +                       printk("\n");
>> +               }
>>         }
>>         return 0;
>>  }
>>
>
> Why not print it only once on original error level?
> Something like:
> static bool printed = false;
> if (!printed) {
>        ...
>        printed = true;
> }
>
> It has the same effect for you (no spamming by default) and it's still provide some information.

Should be per-monitor or per-output I think.

-- 
Rafał
