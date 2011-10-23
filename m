Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab1JWQpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 12:45:00 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46973 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab1JWQo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 12:44:58 -0400
MIME-Version: 1.0
In-Reply-To: <201110222343.24141.heiko@sntech.de>
References: <1319257301-5040-1-git-send-email-paul.s.schilling@gmail.com>
	<201110222343.24141.heiko@sntech.de>
Date: Sun, 23 Oct 2011 11:44:57 -0500
Message-ID: <CAC=G6szC+S2oTSVf-KEXZHxc9cFHOqQeoOLaKhA6QWwSjQ=7Bg@mail.gmail.com>
Subject: Re: [PATCH 06/14] ARM : SAMSUNG : S3C2416 Added io mapping for Static
 memory controller.
From: Paul Schilling <paul.s.schilling@gmail.com>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>,
        Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why did I add disabled code.  I didn't want to enable it if no one is
using it at the moment.
But,  I took me long enough to figure out how to enable the Static
memory Controller in the
MMU with out any hints to begin with.

Also the EBI portion is present in a vendor kernel version 2.6.21.

The Static Memory Controller peripheral needs to be set when ethernet
chips like the dm9000 is attached to the
samsung  ARM S3C2416.  The Boardcon board is a good example.

On Sat, Oct 22, 2011 at 4:43 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Samstag 22 Oktober 2011, 06:21:41 schrieb Paul Schilling:
>> Added MMU access to the Static Memory Controller.
>>
>> Signed-off-by: Paul Schilling <paul.s.schilling@gmail.com>
>> ---
>>  arch/arm/mach-s3c2416/s3c2416.c |   12 ++++++++++++
>>  1 files changed, 12 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-s3c2416/s3c2416.c
>> b/arch/arm/mach-s3c2416/s3c2416.c index 494ce91..823a034 100644
>> --- a/arch/arm/mach-s3c2416/s3c2416.c
>> +++ b/arch/arm/mach-s3c2416/s3c2416.c
>> @@ -65,6 +65,18 @@ static struct map_desc s3c2416_iodesc[] __initdata = {
>>       IODESC_ENT(WATCHDOG),
>>       IODESC_ENT(CLKPWR),
>>       IODESC_ENT(TIMER),
>> +     {
>> +             .virtual        = (u32)S3C2412_VA_SSMC,
>> +             .pfn            = __phys_to_pfn(S3C2412_PA_SSMC),
>> +             .length         = SZ_1M,
>> +             .type           = MT_DEVICE,
>> +     },
>> +     /*{
>> +             .virtual        = (u32)S3C2412_VA_EBI,
>> +             .pfn            = __phys_to_pfn(S3C2412_PA_EBI),
>> +             .length         = SZ_1M,
>> +             .type           = MT_DEVICE,
>> +     },*/
>>  };
> why are you adding disabled code?
>
> Btw. it seems your posts got mangled somehow... only your patches 2,5 and 6 of
> 14 made it to linux-kernel and linux-arm-kernel.
>
> Heiko
>
