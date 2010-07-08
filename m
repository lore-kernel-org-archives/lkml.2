Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0GHQzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 12:55:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62178 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab0GHQzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 12:55:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=mfpOKwLHqVkpFPvPGg8IK831xAbmYC4F91RyyturTmZIhxjhKV436REvOJ/MQu9j6X
         y/8mZvoDFRj20IYUcFdcHnZk4VSD19KckLAfaJlnmCr3uZjcawkLcoz8gAdMC5g3562J
         ZcVjMOEGfACPSDUAA7J1gdg7beAfJVenJ9lO8=
Date: Thu, 8 Jul 2010 20:55:09 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: LEROY Christophe <christophe.leroy@c-s.fr>, linux-kernel@vger.kernel.org,
       LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
       Kumar Gala <galak@kernel.crashing.org>
Subject: Re: 2.6.34: arch/powerpc/sysdev/micropatch.c not compiling
Message-ID: <20100708165509.GA15181@oksana.dev.rtsoft.ru>
References: <4C318D87.1010306@c-s.fr>
 <20100706000343.GE23985@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100706000343.GE23985@ozlabs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 10:03:43AM +1000, Tony Breeds wrote:
> On Mon, Jul 05, 2010 at 09:45:11AM +0200, LEROY Christophe wrote:
> > When activating micropatch option, the kernel does not compile.
> 
> powerpc problems should alos CC linuxppc-dev.
>  
> > It looks like a spi_t is not defined anywhere.
> > 
> > CC arch/powerpc/sysdev/micropatch.o
> > arch/powerpc/sysdev/micropatch.c: In function ‘cpm_load_patch’:
> > arch/powerpc/sysdev/micropatch.c:629: erreur: expected ‘=’, ‘,’,
> > ‘;’, ‘asm’ or ‘__attribute__’ before ‘*’ token
[...]
> -       spp = (spi_t *)&commproc->cp_dparam[PROFF_SPI];
> -       spp->spi_rpbase = i;
> +       smp = (smc_uart_t *)&commproc->cp_dparam[PROFF_SPI];
> +       smp->smc_rpbase = i;
>  
>  # if defined(CONFIG_I2C_SPI_UCODE_PATCH)
>         commproc->cp_cpmcr1 = 0x802a;
> 
> 
> Would help?

While this will fix the issue, I think this is not technically
correct (i.e. micropatching SPI controller via I2C pram struct,
even though the structs appear to be identical).

As the spi_param is needed outside of the SPI driver, we'd
better re-introduce the struct, I think.

I'll send some fixes for this and other issues in this file.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
