Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab0CZViI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:38:08 -0400
Received: from server78.greatnet.de ([83.133.96.102]:52851 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab0CZViG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:38:06 -0400
Message-ID: <4BAD2936.2050106@nachtwindheim.de>
Date: Fri, 26 Mar 2010 22:37:58 +0100
From: Henrik Kretzschmar <henne@nachtwindheim.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-fbdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       Andres Salomon <dilinger@debian.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix section mismatches in virtual framebuffer
References: <1269433035-6141-1-git-send-email-henne@nachtwindheim.de> <20100326104026.5cda2fbf.randy.dunlap@oracle.com>
In-Reply-To: <20100326104026.5cda2fbf.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, this patch is crap.

These structures can be freed cause they are struct and not struct*
But they should be __devinitdata.

I'm going to resend this and a couple of other fb-patches tomorrow.

Thanks 

Randy Dunlap schrieb:

> [adding linux-fbdev mailing list]
>
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
>
>
> On Wed, 24 Mar 2010 13:17:15 +0100 Henrik Kretzschmar wrote:
>
>   
>> Both structs, vfb_default and vfb_fix, should not be freed,
>> since they are referenced and used by the struct fb_info of that device.
>>
>> WARNING: drivers/video/vfb.o(.devinit.text+0x13f): Section mismatch in
>> reference from the function vfb_probe() to the variable
>> .init.data:vfb_default
>> The function __devinit vfb_probe() references
>> a variable __initdata vfb_default.
>> If vfb_default is only used by vfb_probe then
>> annotate vfb_default with a matching annotation.
>>
>> WARNING: drivers/video/vfb.o(.devinit.text+0x162): Section mismatch in
>> reference from the function vfb_probe() to the variable
>> .init.data:vfb_fix
>> The function __devinit vfb_probe() references
>> a variable __initdata vfb_fix.
>> If vfb_fix is only used by vfb_probe then
>> annotate vfb_fix with a matching annotation.
>>
>> WARNING: drivers/video/vfb.o(.devinit.text+0x177): Section mismatch in
>> reference from the function vfb_probe() to the variable
>> .init.data:vfb_fix
>> The function __devinit vfb_probe() references
>> a variable __initdata vfb_fix.
>> If vfb_fix is only used by vfb_probe then
>> annotate vfb_fix with a matching annotation.
>>
>> WARNING: drivers/video/vfb.o(.devinit.text+0x184): Section mismatch in
>> reference from the function vfb_probe() to the (unknown reference)
>> .init.data:(unknown)
>> The function __devinit vfb_probe() references
>> a (unknown reference) __initdata (unknown).
>> If (unknown) is only used by vfb_probe then
>> annotate (unknown) with a matching annotation.
>>
>> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
>> ---
>>  drivers/video/vfb.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/video/vfb.c b/drivers/video/vfb.c
>> index b8ab995..ae5796d 100644
>> --- a/drivers/video/vfb.c
>> +++ b/drivers/video/vfb.c
>> @@ -79,7 +79,7 @@ static void rvfree(void *mem, unsigned long size)
>>  	vfree(mem);
>>  }
>>  
>> -static struct fb_var_screeninfo vfb_default __initdata = {
>> +static struct fb_var_screeninfo vfb_default = {
>>  	.xres =		640,
>>  	.yres =		480,
>>  	.xres_virtual =	640,
>> @@ -101,7 +101,7 @@ static struct fb_var_screeninfo vfb_default __initdata = {
>>        	.vmode =	FB_VMODE_NONINTERLACED,
>>  };
>>  
>> -static struct fb_fix_screeninfo vfb_fix __initdata = {
>> +static struct fb_fix_screeninfo vfb_fix = {
>>  	.id =		"Virtual FB",
>>  	.type =		FB_TYPE_PACKED_PIXELS,
>>  	.visual =	FB_VISUAL_PSEUDOCOLOR,
>> -- 
>>     
>
>
> ---
> ~Randy
>
>   

