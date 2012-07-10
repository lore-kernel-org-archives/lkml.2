Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab2GJNfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 09:35:20 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:49693 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499Ab2GJNfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 09:35:19 -0400
Message-ID: <4FFC2F95.7080003@msgid.tls.msk.ru>
Date: Tue, 10 Jul 2012 17:35:17 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Andrew Hunter <ahh@google.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] core-kernel: use multiply instead of shifts in hash_64
References: <20120702202534.GC844@google.com>
In-Reply-To: <20120702202534.GC844@google.com>
X-Enigmail-Version: 1.4.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.07.2012 00:25, Andrew Hunter wrote:
> diff --git a/include/linux/hash.h b/include/linux/hash.h
> index b80506b..daabc3d 100644
> --- a/include/linux/hash.h
> +++ b/include/linux/hash.h
> @@ -34,7 +34,9 @@
>  static inline u64 hash_64(u64 val, unsigned int bits)
>  {
>  	u64 hash = val;
> -
> +#if BITS_PER_LONG == 64
> +	hash *= GOLDEN_RATIO_PRIME_64;
> +#else
>  	/*  Sigh, gcc can't optimise this alone like it does for 32 bits. */

Hmm.  Does this comment make sense here now?

Thanks,

/mjt
