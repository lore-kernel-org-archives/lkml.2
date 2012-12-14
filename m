Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab2LNB3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:29:25 -0500
Received: from intranet.asianux.com ([58.214.24.6]:46841 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab2LNB3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:29:24 -0500
X-Spam-Score: -100.8
Message-ID: <50CA8129.2020206@asianux.com>
Date: Fri, 14 Dec 2012 09:30:17 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Omar Ramirez Luna <omar.ramirez@copitl.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] drivers/staging/tidspbridge: pr_err and pr_debug
 for uninitialized buffer (name buf not initialized).
References: <50C85644.7020203@asianux.com> <50C858AA.8080305@asianux.com> <CAJ6Av5OC+2wdfhb2FExv8NM7Hsyu4_1qnCWV22di8_psw4gF4Q@mail.gmail.com>
In-Reply-To: <CAJ6Av5OC+2wdfhb2FExv8NM7Hsyu4_1qnCWV22di8_psw4gF4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年12月14日 02:25, Omar Ramirez Luna 写道:
> Hi Chen,
> 
> Thanks for your report.
> 
> On Wed, Dec 12, 2012 at 4:12 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>   excuse me,  I have to forward this mail to you.
>>   I have sent it to Omar Ramirez Luna <omar.ramirez@ti.com>, but failed.
>>    (get mail delivery failed )
> 
> Please contact me with my new address (this one).

  is it suitable to modify the MAINTAINER file for your mail address ?
    if suitable, please help modify it, I am not quite familiar with it.

  also another suggestions:
    I built ti otmap with ti dsp bridge by arm cross-compiler under i386 platform.
    the version tag is next-20121213
    I met 2 compiling issues.

      a: module dependency:
        Multifunction device drivers --> Texas Instruments TWL/4030/TWL5030.... is required for TI OTMAP.
        it need depend on CONFIG_REGMAP (maybe also inculde CONFIG_REGMAP*)
        if CONFIG_REGMAP* not defined, building will be failed.

      b: version merging issue:
        in drivers/staging/tidspbridge/core/_tiomap.h
        need use "#include <mach-omap2/cm3xxx.h>" instead of "#include <mach-omap2/cm2xxx_3xxx.h>"
        the macro OMAP3430_CM_AUTOIDLE_PLL has already move from cm2xxx_3xxx.h to cm3xxx.h.
          (it seems arch/arm/mach-omap2/ is not a suitable place for including, but we have to)
        if not change, compiling will be failed.

  please also help to check the 2 compiling issues, thanks.

  if these suggestions are valid,
    please help to send patches for them,
    better to mark me as Reported-by.
    not need cc to me (for I am not reviewer)


  Regards

gchen.


> 
> I'll take a look at these.
> 
> Cheers,
> 
> Omar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


-- 
Chen Gang

Asianux Corporation
