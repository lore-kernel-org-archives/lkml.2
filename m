Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab1GHOaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 10:30:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53708 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1GHOaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 10:30:19 -0400
Message-ID: <4E171477.8060303@gmail.com>
Date: Fri, 08 Jul 2011 09:30:15 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 09/11] arm/dt: Add dt machine definition
References: <20110616042653.29371.2052.stgit@ponder> <20110616044248.29371.69457.stgit@ponder>
In-Reply-To: <20110616044248.29371.69457.stgit@ponder>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

On 06/15/2011 11:42 PM, Grant Likely wrote:
> This patch adds a DT_MACHINE_START macro to use instead of
> MACHINE_START when creating a machine_desc that supports using the
> device tree.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/arm/include/asm/mach/arch.h |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
> index 946f4d7..858d269 100644
> --- a/arch/arm/include/asm/mach/arch.h
> +++ b/arch/arm/include/asm/mach/arch.h
> @@ -70,4 +70,13 @@ static const struct machine_desc __mach_desc_##_type	\
>  #define MACHINE_END				\
>  };
>  
> +#define MACH_TYPE_DT	0xffffffff
> +
> +#define DT_MACHINE_START(_name, _namestr)		\
> +static const struct machine_desc __mach_desc_##_name	\
> + __used							\
> + __attribute__((__section__(".arch.info.init"))) = {	\
> +	.nr		= MACH_TYPE_DT,			\
> +	.name		= _namestr,
> +
>  #endif
> 

Do you plan to submit this for 3.1 as new platforms need this or a mach id?

Rob


