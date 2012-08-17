Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab2HQK2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:28:19 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46338 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526Ab2HQK2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:28:15 -0400
MIME-Version: 1.0
In-Reply-To: <1345191768.27859.26.camel@sauron.fi.intel.com>
References: <1345042639.3393.150.camel@sauron.fi.intel.com>
 <1345128723-13582-2-git-send-email-richard.genoud@gmail.com> <1345191768.27859.26.camel@sauron.fi.intel.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 17 Aug 2012 12:27:53 +0200
Message-ID: <CACQ1gAj-+-NL4EnF1AAFy7BBrY97c_UFW3+5iyTVdxN9XETS=w@mail.gmail.com>
Subject: Re: [PATCH 1/2] UBI: replace MTD_UBI_BEB_LIMIT with module parameter
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/17 Artem Bityutskiy <dedekind1@gmail.com>:
> Richard, would you please split this series differently:
>
> 1. Separate out the calculations to the get_bad_peb_limit() func.
> 2. Invent
> 2. Add the module parameter
> 3. Extends the ioctl
> 4. Removes the Kconfig option
>
> This will be much easier to review.
ok, will do that.

>
> See also some comments below.
>
>> --- a/drivers/mtd/ubi/build.c
>> +++ b/drivers/mtd/ubi/build.c
>> @@ -46,6 +46,8 @@
>>  /* Maximum length of the 'mtd=' parameter */
>>  #define MTD_PARAM_LEN_MAX 64
>>
>> +#define MTD_PARAM_NB_MAX 3
>
> Please, make it to be
>
> /* Maximum number of comma-separated items in ht 'mtd=' parameter */
> #define MTD_PARAM_MAX_COUNT 3
>
> instead.
done.
>
>> @@ -57,10 +59,12 @@
>>   * @name: MTD character device node path, MTD device name, or MTD device number
>>   *        string
>>   * @vid_hdr_offs: VID header offset
>> + * @max_beb_per1024: maximum expected number of bad blocks per 1024 erase blocks
>>   */
>>  struct mtd_dev_param {
>>       char name[MTD_PARAM_LEN_MAX];
>>       int vid_hdr_offs;
>> +     unsigned int max_beb_per1024;
>>  };
>
> Please, make it to be just 'int' here and everywhere, just for
> consistency with other parameters, which are 'int' (no other stronger
> reason).
ok, I put it back to an int.

>>  MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: "
>> -                   "mtd=<name|num|path>[,<vid_hdr_offs>].\n"
>> +                   "mtd=<name|num|path>[,<vid_hdr_offs>[,max_beb_per1024]].\n"
>>                     "Multiple \"mtd\" parameters may be specified.\n"
>>                     "MTD devices may be specified by their number, name, or "
>>                     "path to the MTD character device node.\n"
>>                     "Optional \"vid_hdr_offs\" parameter specifies UBI VID "
>>                     "header position to be used by UBI.\n"
>
> This comment needs improvement. Consider a situation when I do not want
> to specify vid_hdr_offs (want to use the default), but want to specify
> max_beb_per1024. I think I can put 0 here which means "default". Would
> you please verify this and add a comment about this in this help output.
you're right, if vid_hdr_offs is 0, the default value is taken.
I'll improve the comments accordingly.
> Also, please, verify that the output looks OK using 'modinfo ubi'.
ok.
>> +                   "Optional \"max_beb_per1024\" parameter specifies the "
>> +                   "maximum expected bad eraseblock per 1024 eraseblocks."
>> +                   "(default " __stringify(MTD_UBI_DEFAULT_BEB_LIMIT)
>> +                   " if 0 or not set)\n"
>
> Yeah, something like "if 0 or not set" is needed for 'vid_hdr_offs' as
> well.
>
>>                     "Example 1: mtd=/dev/mtd0 - attach MTD device "
>>                     "/dev/mtd0.\n"
>>                     "Example 2: mtd=content,1984 mtd=4 - attach MTD device "
>
> Could you also modify one of the examples and add "max_beb_per1024"
> there?
yes, of course.

> --
> Best Regards,
> Artem Bityutskiy



-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
