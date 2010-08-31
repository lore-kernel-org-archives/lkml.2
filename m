Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0HaFtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 01:49:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40954 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab0HaFtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 01:49:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AbLj/FJ8wVMD1fnAY/a394GscmYbMwvEPJsRH2AXMONy4PhHlDbiCbu6eOnHtWYava
         vVbG4EzWhk8hmbTkhi+N9SgBH3IqY73WfH1+jdJ+LRYZ7Tqm4X7SM5dc3sn79yg12pnA
         uuUY5d2GB1vJpdT5Fj1E8tkxUmDASwZmHjjFw=
MIME-Version: 1.0
In-Reply-To: <1282813649-8332-2-git-send-email-mark.brown314@gmail.com>
References: <1282813649-8332-1-git-send-email-mark.brown314@gmail.com> <1282813649-8332-2-git-send-email-mark.brown314@gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 31 Aug 2010 13:48:50 +0800
Message-ID: <AANLkTi=GZ1p3MzibOEzhyD=Mv6d2x2nRh93D4bmtgcYE@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: pxa168: fix corrected reset vector
To: "Mark F. Brown" <mark.brown314@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 5:07 PM, Mark F. Brown <mark.brown314@gmail.com> wrote:
> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
> ---
>  arch/arm/mach-mmp/include/mach/system.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-mmp/include/mach/system.h b/arch/arm/mach-mmp/include/mach/system.h
> index 4f5b0e0..926e9c0 100644
> --- a/arch/arm/mach-mmp/include/mach/system.h
> +++ b/arch/arm/mach-mmp/include/mach/system.h
> @@ -16,6 +16,6 @@ static inline void arch_idle(void)
>
>  static inline void arch_reset(char mode, const char *cmd)
>  {
> -       cpu_reset(0);
> +       cpu_reset(0xffff0000);

Not sure if this correct. But normally reset jump happens after we turn
off the MMU and so on. Ain't the BootROM starts from 0 ?

>  }
>  #endif /* __ASM_MACH_SYSTEM_H */
> --
> 1.7.0.4
>
>
