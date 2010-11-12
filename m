Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab0KLJ5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 04:57:23 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40351 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab0KLJ5W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 04:57:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wwxp/Jt7Jbx1H3duoUPeKCB/GI8Scwmt71hxkz4paeo5jrC/ruritQgMmDRWGrCHya
         7mjc4HPqRDANZRlQs2B1iR5fzlBkSmb7DQ+bXGP6tpyWP1RE/f2sT/Zm/cPxlWi/NTDI
         GQUZ9Et9Ov3JfsjXZyyLz6sRzLhIAeCsajc+w=
MIME-Version: 1.0
In-Reply-To: <20101110083814.55e222c4.rdunlap@xenotime.net>
References: <1289384128-19823-1-git-send-email-marek.belisko@gmail.com>
	<20101110083814.55e222c4.rdunlap@xenotime.net>
Date: Fri, 12 Nov 2010 10:57:19 +0100
Message-ID: <AANLkTimrLMpGBMy0xRkQ3fFEizgVeVY8ztSf1CmoSi=k@mail.gmail.com>
Subject: Re: [PATCH 1/3] staging: ft1000: Fix compilation warning.
From: Belisko Marek <marek.belisko@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Wed, Nov 10, 2010 at 5:38 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Wed, 10 Nov 2010 11:15:26 +0100 Marek Belisko wrote:
>
>> Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
>> ---
>>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>
>
> a.  always include the warning or error message that the patch fixes
>
> b.  (quoting from another email yesterday:)
>
> so in your analysis of this compiler warning, was the warning correct & justified,
> or was it false?  I.e., is the init to NULL needed?
After code analysis NULL assignment is necessary. Function have
multiple goto statements
and pointer is assigned after some goto are placed. In one of
statements at the end of function
there is kthread stopping which use pft1000info pointer (this part
isn't applicable if pft1000info isn't initialized).
Hopefully this is what compiler complain about (could return with some
goto statement but pft1000info isn't initialized but
used). This warning was introduced when make common return point for
some error states.
>
> If it was false, could we just silence the warning by using:
>
>        struct ft1000_info *unitialized_var(pft1000info);
>
> plus #include <linux/compiler.h> ?
>
>
>> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
>> index 99e3339..b7c4602 100644
>> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
>> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
>> @@ -64,7 +64,7 @@ static int ft1000_probe(struct usb_interface *interface,
>>       int i, ret = 0, size;
>>
>>       struct ft1000_device *ft1000dev;
>> -     struct ft1000_info *pft1000info;
>> +     struct ft1000_info *pft1000info = NULL;
>>       const struct firmware *dsp_fw;
>>
>>       ft1000dev = kmalloc(sizeof(struct ft1000_device), GFP_KERNEL);
>> --
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>

thanks,

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
