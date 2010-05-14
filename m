Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab0ENNaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 09:30:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46895 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752874Ab0ENNaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 09:30:00 -0400
Subject: Re: [PATCH v2] [RESEND] Handle instruction cache maintenance fault
 properly
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Russell King <linux@arm.linux.org.uk>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Aaro Koskinen <aaro.koskinen@nokia.com>, Valdis.Kletnieks@vt.edu
In-Reply-To: <AANLkTilVp0xvAJNns3TEe4SzEUpN8hMC9DdwmwW7i9yX@mail.gmail.com>
References: <AANLkTilVp0xvAJNns3TEe4SzEUpN8hMC9DdwmwW7i9yX@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 14 May 2010 14:29:40 +0100
Message-ID: <1273843780.28312.27.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2010 13:29:41.0318 (UTC) FILETIME=[82179660:01CAF369]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 11:33 +0100, Kirill A. Shutemov wrote:
> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> index 9d40c34..7f193ea 100644
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -463,7 +463,12 @@ static struct fsr_info {
>         { do_bad,               SIGILL,  BUS_ADRALN,    "alignment exception"              },
>         { do_bad,               SIGKILL, 0,             "terminal exception"               },
>         { do_bad,               SIGILL,  BUS_ADRALN,    "alignment exception"              },
> +/* Do we need runtime check ? */
> +#if __LINUX_ARM_ARCH__ < 6
>         { do_bad,               SIGBUS,  0,             "external abort on linefetch"      },
> +#else
> +       { do_translation_fault, SIGSEGV, SEGV_MAPPER,   "I-cache maintenance
> fault"     },
> +#endif

Apart from line wrapping, it should be SEGV_MAPERR above.

-- 
Catalin

