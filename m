Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab0HYRYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 13:24:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0HYRYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 13:24:23 -0400
Message-ID: <4C7551B1.3000703@redhat.com>
Date: Wed, 25 Aug 2010 13:24:01 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
CC: Colin Watson <cjwatson@canonical.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] Add new linearfb driver
References: <20100825141111.GI21862@riva.ucam.org> <20100825190438.55ecb34d@neptune.home>
In-Reply-To: <20100825190438.55ecb34d@neptune.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 01:04 PM, Bruno Prémont wrote:
> On Wed, 25 August 2010 Colin Watson <cjwatson@canonical.com> wrote:
>> Split out linearfb from efifb so that boot loaders can program it as a
>> simple linear framebuffer on non-EFI systems.  This is useful for boot
>> loaders with their own graphics drivers, e.g. GRUB 2, since in some
>> cases on x86 they can set up non-VESA modes and thus can't program
>> vesafb.
>>
>> efifb is reworked on top of this common code, and it should be possible
>> to do the same with some other framebuffer drivers in future.
>>
>> Signed-off-by: Colin Watson <cjwatson@canonical.com>
>> Acked-by: Matthew Garrett <mjg@redhat.com>
>> Cc: Peter Jones <pjones@redhat.com>
>> ---
>>  drivers/video/Kconfig       |   17 ++-
>>  drivers/video/Makefile      |    1 +
>>  drivers/video/efifb.c       |  222 +----------------------------
>>  drivers/video/linearfb.c    |  332 +++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/fb.h          |    8 +
>>  include/linux/screen_info.h |    2 +
>>  6 files changed, 364 insertions(+), 218 deletions(-)
>>  create mode 100644 drivers/video/linearfb.c
>>
>> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
>> index 59c51d9..a7735ec 100644
>> --- a/drivers/video/Kconfig
>> +++ b/drivers/video/Kconfig
>> @@ -721,13 +721,24 @@ config FB_VESA
>>  	  You will get a boot time penguin logo at no additional cost. Please
>>  	  read <file:Documentation/fb/vesafb.txt>. If unsure, say Y.
>>  
>> -config FB_EFI
>> -	bool "EFI-based Framebuffer Support"
>> -	depends on (FB = y) && X86 && EFI
>> +config FB_LINEAR
>> +	bool "Simple linear framebuffer support"
>> +	depends on FB
>>  	select FB_CFB_FILLRECT
>>  	select FB_CFB_COPYAREA
>>  	select FB_CFB_IMAGEBLIT
>         ^^^^^^^^^^^^^^^^^^^^^^^
> 
>>  	help
>> +	  This is a simple linear frame buffer device driver. It has no
>> +	  hardware-specific programming capability, but must be programmed
>> +	  by the boot loader or by another frame buffer driver.
>> +
>> +	  If unsure, say N.
>> +
>> +config FB_EFI
>> +	bool "EFI-based Framebuffer Support"
>> +	depends on (FB = y) && X86 && EFI
>> +	select FB_LINEAR
>         ^^^^^^^^^^^^^^^^
>   Has kconfig been adjusted to process select recursively?
>   If not the selects from FB_LINEAR will have to be copied here.

This could also be solved by just making it depend on FB_LINEAR instead of
using "select".

-- 
        Peter

I number the Linux folks among my personal heroes.
		-- Donald Knuth

01234567890123456789012345678901234567890123456789012345678901234567890123456789
