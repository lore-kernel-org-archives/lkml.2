Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab1CWK1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:27:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37053 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab1CWK1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:27:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=p0eduF4NXg1LqlNznBd3qXrt4ajdfb8bQXeUjGULZXGgyLEQvwrv0+dUHwsawqZSQv
         xrMxRvfuhzkZYc4nf5VjPJ2ajKbOWUw+AB5MnYgFD8SIZR+ldVSoXt39nK3L46ea0C4N
         5VUCw3PD0Yw5GiD1y4FLehMTQX9+FMdNHx9+E=
Message-ID: <4D89CB04.70003@gmail.com>
Date: Wed, 23 Mar 2011 11:27:16 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Marek Belisko <marek.belisko@open-nandra.com>
CC: gregkh@suse.de, devel@driverdev.osuosl.org,
        Stano Lanci <chl.pixo@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ft1000-pcmcia: Fix ft1000_dnld() to work also
 on 64bit architectures.
References: <1300864088-24438-1-git-send-email-marek.belisko@open-nandra.com>
In-Reply-To: <1300864088-24438-1-git-send-email-marek.belisko@open-nandra.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 08:08 AM, Marek Belisko wrote:
> From: pixo <pixo@pixo-LIFEBOOK-E8310.(none)>
> 
> Firmware file needs to be read by 4bytes also on 64 bit architectures.
> Change long type to u32 and also extend checking. Tested on 32 and also
> 64 bit architectures.
> 
> Signed-off-by: Stano Lanci <chl.pixo@gmail.com>
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> 
> Tested-by: Stano Lanci <chl.pixo@gmail.com>
> ---
>  drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |   78 ++++++++++----------
>  1 files changed, 39 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
> index b0729fc..fb375ea 100644
> --- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
> +++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
> @@ -95,47 +95,47 @@ void put_request_value(struct net_device *dev, long lvalue);
>  USHORT hdr_checksum(PPSEUDO_HDR pHdr);
>  
>  typedef struct _DSP_FILE_HDR {
> -	long build_date;
> -	long dsp_coff_date;
> -	long loader_code_address;
> -	long loader_code_size;
> -	long loader_code_end;
> -	long dsp_code_address;
> -	long dsp_code_size;
> -	long dsp_code_end;
> -	long reserved[8];
> +	u32  build_date;
> +	u32  dsp_coff_date;
> +	u32  loader_code_address;
> +	u32  loader_code_size;
> +	u32  loader_code_end;
> +	u32  dsp_code_address;
> +	u32  dsp_code_size;
> +	u32  dsp_code_end;
> +	u32  reserved[8];
>  } __attribute__ ((packed)) DSP_FILE_HDR, *PDSP_FILE_HDR;

As you also changed signedness, did you check (or do you know) that the
values cannot be negative?

Or at least the change doesn't affect code flow?

regards,
-- 
js
