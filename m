Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab1I1N5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:57:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62364 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab1I1N5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:57:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 18/24] C6X: ptrace support
Date: Wed, 28 Sep 2011 15:57:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-19-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-19-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281557.47986.arnd@arndb.de>
X-Provags-ID: V02:K0:lLCpcqaX7g+WoHQzQG6e5+2BfwhVcLFt+gNXITs5M4G
 QDk2Uv7/7uMHqdQRRoUwWE876ct4hYr32a6ZEOr9GyhW6Q+7oJ
 GEUjzx4FVOEfAOqu6pR/8uWYnR2XFiJUxeGsserSx9l7BCDUId
 Y3Y5pAkzYykAPFI6+pvB0XuimJIzT5chCgVcma+uJ4vsMAJfNW
 KoFgEz3tKvAD9gy/NHFzO0KYl7/xh5eyUooTdPpTLMMkcVLSEy
 kobeTgm7FSWpvBzIM/PJ04Lm+y1uS1DfOhyaRB3vuVBk5FSSgP
 l9WyW6MI5HKX0cdCIYlif29/Rs4kYE09AdrDTwr63KnX3ohtZL
 LRMRDAPhonpeN7o8KPtg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Mark Salter wrote:
> +       case PTRACE_GETREGS:
> +               return copy_regset_to_user(child, &user_c6x_native_view,
> +                                          REGSET_GPR,
> +                                          0, NR_PTREGS * sizeof(long),
> +                                          datap);
> +
> +               /*
> +                * set all gp regs in the child.
> +                */
> +       case PTRACE_SETREGS:
> +               return copy_regset_from_user(child, &user_c6x_native_view,
> +                                            REGSET_GPR,
> +                                            0, NR_PTREGS * sizeof(long),
> +                                            datap);
> +

I believe that you can let this be handled by the common 
ptrace_request() function if you provide the necessary code for
setting CONFIG_HAVE_ARCH_TRACEHOOK, which is preferred now.

	Arnd
