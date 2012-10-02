Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab2JBRUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:20:00 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:54030 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752547Ab2JBRT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:19:59 -0400
X-Greylist: delayed 1737 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Oct 2012 13:19:59 EDT
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 03/17] ARM: pxa: Wunused-result warning in viper board file
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 02 Oct 2012 18:50:55 +0200
From: Marc Zyngier <maz@misterjones.org>
Cc: <linux-arm-kernel@infradead.org>, <arm@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>
Organization: Metropolis
In-Reply-To: <1349195816-2225-4-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de> <1349195816-2225-4-git-send-email-arnd@arndb.de>
Message-ID: <52173c1c1959ad9cd89b3d86a81acef2@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: arnd@arndb.de, linux-arm-kernel@infradead.org, arm@kernel.org, linux-kernel@vger.kernel.org, haojian.zhuang@gmail.com, eric.y.miao@gmail.com
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Oct 2012 18:36:42 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> Calling kstrtoul requires checking the result. In case of
> the viper_tpm_setup function, let's fail the __setup function
> if the number was invalid.
> 
> Without this patch, building viper_defconfig results in:
> 
> arch/arm/mach-pxa/viper.c: In function 'viper_tpm_setup':
> arch/arm/mach-pxa/viper.c:771:10: warning: ignoring return value of
> 'kstrtoul', declared with attribute warn_unused_result [-Wunused-result]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Marc Zyngier <maz@misterjones.org>

Acked-by: Marc Zyngier <maz@misterjones.org>

> ---
>  arch/arm/mach-pxa/viper.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/viper.c b/arch/arm/mach-pxa/viper.c
> index 130379f..ac733e9 100644
> --- a/arch/arm/mach-pxa/viper.c
> +++ b/arch/arm/mach-pxa/viper.c
> @@ -768,8 +768,7 @@ static unsigned long viper_tpm;
>  
>  static int __init viper_tpm_setup(char *str)
>  {
> -	strict_strtoul(str, 10, &viper_tpm);
> -	return 1;
> +	return strict_strtoul(str, 10, &viper_tpm) >= 0;
>  }
>  
>  __setup("tpm=", viper_tpm_setup);

-- 
Who you jivin' with that Cosmik Debris?
