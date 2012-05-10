Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761466Ab2EJAT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:19:28 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:57185 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761360Ab2EJAT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:19:26 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/O76cMkHTOvyqSqzsGiurGipkVxqRbGoCfXkAj/D
	MxNGekyqtuLsS6
Message-ID: <4FAB0986.6090006@gmx.de>
Date: Thu, 10 May 2012 00:19:18 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Icedove/3.0.11
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: Thomas Winischhofer <thomas@winischhofer.net>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video/sis: Annotate SiS_DRAMType as __devinitconst
References: <4FA2FD10.6090306@gmx.de> <1336083295-7327-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1336083295-7327-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 10:14 PM, Peter Huewe wrote:
> SiS_DRAMType is const and only used by sisfb_post_300_rwtest which is
> marked __devinit we can annotate SiS_DRAMType with __devinitconst and
> move it into the file scope in order to not have it created on the
> stack.
> This patch decreases the compiled module size by about 100bytes.
> 
> And since hardcoded values are bad we use ARRAY_SIZE for determining
> the size of SiS_DRAMType ;)
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Good that you did this one, it was more to be done than I expected. I
ignored the checkpatch errors as you didn't introduce them but maybe it
wouldn't be a bad idea to fix things up if you touch them. Applied.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/sis/sis_main.c |   41 +++++++++++++++++++++--------------------
>  1 files changed, 21 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
> index 078ca21..a7a48db 100644
> --- a/drivers/video/sis/sis_main.c
> +++ b/drivers/video/sis/sis_main.c
> @@ -4222,6 +4222,26 @@ sisfb_post_300_buswidth(struct sis_video_info *ivideo)
>  	return 1;			/* 32bit */
>  }
>  
> +static const unsigned short __devinitconst SiS_DRAMType[17][5] = {
> +	{0x0C,0x0A,0x02,0x40,0x39},
> +	{0x0D,0x0A,0x01,0x40,0x48},
> +	{0x0C,0x09,0x02,0x20,0x35},
> +	{0x0D,0x09,0x01,0x20,0x44},
> +	{0x0C,0x08,0x02,0x10,0x31},
> +	{0x0D,0x08,0x01,0x10,0x40},
> +	{0x0C,0x0A,0x01,0x20,0x34},
> +	{0x0C,0x09,0x01,0x08,0x32},
> +	{0x0B,0x08,0x02,0x08,0x21},
> +	{0x0C,0x08,0x01,0x08,0x30},
> +	{0x0A,0x08,0x02,0x04,0x11},
> +	{0x0B,0x0A,0x01,0x10,0x28},
> +	{0x09,0x08,0x02,0x02,0x01},
> +	{0x0B,0x09,0x01,0x08,0x24},
> +	{0x0B,0x08,0x01,0x04,0x20},
> +	{0x0A,0x08,0x01,0x02,0x10},
> +	{0x09,0x08,0x01,0x01,0x00}
> +};
> +
>  static int __devinit
>  sisfb_post_300_rwtest(struct sis_video_info *ivideo, int iteration, int buswidth,
>  			int PseudoRankCapacity, int PseudoAdrPinCount,
> @@ -4231,27 +4251,8 @@ sisfb_post_300_rwtest(struct sis_video_info *ivideo, int iteration, int buswidth
>  	unsigned short sr14;
>  	unsigned int k, RankCapacity, PageCapacity, BankNumHigh, BankNumMid;
>  	unsigned int PhysicalAdrOtherPage, PhysicalAdrHigh, PhysicalAdrHalfPage;
> -	static const unsigned short SiS_DRAMType[17][5] = {
> -		{0x0C,0x0A,0x02,0x40,0x39},
> -		{0x0D,0x0A,0x01,0x40,0x48},
> -		{0x0C,0x09,0x02,0x20,0x35},
> -		{0x0D,0x09,0x01,0x20,0x44},
> -		{0x0C,0x08,0x02,0x10,0x31},
> -		{0x0D,0x08,0x01,0x10,0x40},
> -		{0x0C,0x0A,0x01,0x20,0x34},
> -		{0x0C,0x09,0x01,0x08,0x32},
> -		{0x0B,0x08,0x02,0x08,0x21},
> -		{0x0C,0x08,0x01,0x08,0x30},
> -		{0x0A,0x08,0x02,0x04,0x11},
> -		{0x0B,0x0A,0x01,0x10,0x28},
> -		{0x09,0x08,0x02,0x02,0x01},
> -		{0x0B,0x09,0x01,0x08,0x24},
> -		{0x0B,0x08,0x01,0x04,0x20},
> -		{0x0A,0x08,0x01,0x02,0x10},
> -		{0x09,0x08,0x01,0x01,0x00}
> -	};
>  
> -	 for(k = 0; k <= 16; k++) {
> +	 for(k = 0; k < ARRAY_SIZE(SiS_DRAMType); k++) {
>  
>  		RankCapacity = buswidth * SiS_DRAMType[k][3];
>  

