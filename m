Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab2ALXgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 18:36:18 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45450 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756038Ab2ALXgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 18:36:16 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/FwyJT0RDFyw2q6uSZVHm77XCCh3Zxa21FDzmeGw
	Nk9hGApc92s9ek
Message-ID: <4F0F6E65.7020009@gmx.de>
Date: Thu, 12 Jan 2012 23:36:05 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Antonino Daplas <adaplas@gmail.com>, linux-fbdev@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH 3/15] i810: fix module_param bool abuse.
References: <874nx2tu1v.fsf@rustcorp.com.au> <4EEFC5B4.9000704@gmx.de> <87sjjk34wx.fsf@rustcorp.com.au>
In-Reply-To: <87sjjk34wx.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On 01/12/2012 10:57 PM, Rusty Russell wrote:
> On Mon, 19 Dec 2011 23:16:04 +0000, Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
>> On 12/15/2011 03:03 AM, Rusty Russell wrote:
>>> The driver says "module_param(ddc3, bool, 0);".  But it's not a used
>>> as a bool, it's used as a count.
>>>
>>> Make it a bool.
>>>
>>> Cc: Antonino Daplas <adaplas@gmail.com>
>>> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
>>> Cc: linux-fbdev@vger.kernel.org
>>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>>
>> Applied.
> 
> Hmm, I don't see this in Linus' tree yet, and it's a context-clash
> pre-requisite for part of the general driver bool conversion.  I want to
> push today since I have linux.conf.au next week, so I've split the i810
> conversion into a separate patch, below.

Sorry for the delay, but with an OMAP pull and a revert this merge window is not
as quiet as I wished.

> It's been over a week in linux-next, can you push this please?

Sure, I've taken it and also fixed the subject.


Best regards,

Florian Tobias Schandinat

> 
> From: Rusty Russell <rusty@rustcorp.com.au>
> Subject: module_param: make bool parameters really bool (drivers/vidio/i810)
> 
> module_param(bool) used to counter-intuitively take an int.  In
> fddd5201 (mid-2009) we allowed bool or int/unsigned int using a messy
> trick.
> 
> It's time to remove the int/unsigned int option.  For this version
> it'll simply give a warning, but it'll break next kernel version.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/drivers/video/i810/i810_main.c b/drivers/video/i810/i810_main.c
> --- a/drivers/video/i810/i810_main.c
> +++ b/drivers/video/i810/i810_main.c
> @@ -135,8 +135,8 @@ static struct pci_driver i810fb_driver =
>  static char *mode_option __devinitdata = NULL;
>  static int vram       __devinitdata = 4;
>  static int bpp        __devinitdata = 8;
> -static int mtrr       __devinitdata;
> -static int accel      __devinitdata;
> +static bool mtrr      __devinitdata;
> +static bool accel     __devinitdata;
>  static int hsync1     __devinitdata;
>  static int hsync2     __devinitdata;
>  static int vsync1     __devinitdata;
> @@ -144,9 +144,9 @@ static int vsync2     __devinitdata;
>  static int xres       __devinitdata;
>  static int yres;
>  static int vyres      __devinitdata;
> -static int sync       __devinitdata;
> -static int extvga     __devinitdata;
> -static int dcolor     __devinitdata;
> +static bool sync      __devinitdata;
> +static bool extvga    __devinitdata;
> +static bool dcolor    __devinitdata;
>  static bool ddc3      __devinitdata;
>  
>  /*------------------------------------------------------------*/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

