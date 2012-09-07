Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab2IGTwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:52:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61449 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab2IGTwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:52:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 26/31] arm64: Miscellaneous library functions
Date: Fri, 7 Sep 2012 19:52:13 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-27-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-27-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071952.14309.arnd@arndb.de>
X-Provags-ID: V02:K0:Zan588MHhXInEbylf+6R/gWBP6/sGiVt76DBi+d7/Y6
 2s492QbR0airSWZ5ArVNnktFdvY3lceKFqnjxo+Ry+mb9E0pdL
 9z5sHJW6xVgwizenZ2OGRhJixy9kVhy0l49Gy8cYtg7dSPgxPH
 Q1bxlbhyx7nrKs8c7TKSiqclZOFeX+TWJHaeXGhhPsFvZLEh/F
 LCoK1ki6FSe4kvEDbP9ixvCgOKYyf/MHFUP4BfrGGkl5o2AQYK
 IaQDbbYsakx8I3l9FPBT82SGVax04ghAKe9YabSsxE3bPCH1JX
 u99BlddR2gc2ZhR1QzJPi3aVNCZ3UrYzB2uZOkrBHurWUkQ5Mk
 JT3PMeI6bxzBxxIoUfSE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:

> +/*
> + * Use compiler builtins for simple inline operations.
> + */
> +static inline unsigned long __ffs(unsigned long word)
> +{
> +	return __builtin_ffsl(word) - 1;
> +}
> +
> +static inline int ffs(int x)
> +{
> +	return __builtin_ffs(x);
> +}
> +
> +static inline unsigned long __fls(unsigned long word)
> +{
> +	return BITS_PER_LONG - 1 - __builtin_clzl(word);
> +}
> +
> +static inline int fls(int x)
> +{
> +	return x ? sizeof(x) * BITS_PER_BYTE - __builtin_clz(x) : 0;
> +}

Still waiting for the generic version of these.

	Arnd
