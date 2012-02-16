Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab2BPPYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:24:46 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:43120 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab2BPPYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:24:45 -0500
Message-ID: <4F3D1FB4.7070901@free-electrons.com>
Date: Thu, 16 Feb 2012 16:24:36 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linux@arm.linux.org.uk, nicolas.pitre@linaro.org, tony@atomide.com,
        s.hauer@pengutronix.de, magnus.damm@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: remove memmove from boot/compressed/string.c
References: <1329404057-26346-1-git-send-email-michael.opdenacker@free-electrons.com> <1329404057-26346-2-git-send-email-michael.opdenacker@free-electrons.com> <20120216150933.GD19779@game.jcrosoft.org>
In-Reply-To: <20120216150933.GD19779@game.jcrosoft.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Christophe,

On 02/16/2012 04:09 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 15:54 Thu 16 Feb     , Michael Opdenacker wrote:
>> This patch removes the memmove function from boot/compressed/string.c
>> - This definition conflicts with the one in lib/decompress_unxz.c
>>   This change is required to support xz compression on ARM.
>> - memmove is not used in any of the other decompressors
>>   in lib/decompress_*.c
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
>> ---
>>  arch/arm/boot/compressed/string.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/boot/compressed/string.c b/arch/arm/boot/compressed/string.c
>> index 36e53ef..369443a 100644
>> --- a/arch/arm/boot/compressed/string.c
>> +++ b/arch/arm/boot/compressed/string.c
>> @@ -40,6 +40,7 @@ void *memcpy(void *__dest, __const void *__src, size_t __n)
>>  	return __dest;
>>  }
>>  
>> +/*
>>  void *memmove(void *__dest, __const void *__src, size_t count)
>>  {
>>  	unsigned char *d = __dest;
>> @@ -55,6 +56,7 @@ void *memmove(void *__dest, __const void *__src, size_t count)
>>  		d[count] = s[count];
>>  	return __dest;
>>  }
>> +*/
> so why not drop it cleanly
Oooops. Well spotted. You no longer see the obviously stupid stuff in
your own code.

I'll send an update soon.

Thanks!

Michael.

-- 
Michael Opdenacker, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
+33 484 253 396

