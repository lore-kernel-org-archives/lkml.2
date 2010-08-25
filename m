Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0HYGUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 02:20:22 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37458 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751380Ab0HYGUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 02:20:18 -0400
Date: Wed, 25 Aug 2010 08:20:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miloslav Trma? <mitr@redhat.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
Message-ID: <20100825062000.GA1424@ucw.cz>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Motivations for the extensions: governments are asking for more security
> features in the operating systems they procure, which make user-space
> implementations impractical.  A few examples:
> 
> * Advanced crypto module for OSPP for Common Criteria requires OS services
>   implementing several low-level crypto algorithms (e.g. AES, RSA).  This
>   requires the separation of crypto services from the consumer of those
>   services. (The threat model is that apps tend to have more vulnerabilities
>   than libraries and compromise of the app will lead to the ability to access
>   key material.) An user-space library is not separated, options are a) root
>   running daemon that does crypto, but this would be slow due to context
>   switches, scheduler mismatching and all the IPC overhead and b) use crypto
>   that is in the kernel.

Hmm, root daemon seems like a way to go. You already do the switch
into the kernel... and "IPC is slow" is not good enough reason to put
everything in kernel. Plus, you should be able to get better usage of
multicore with daemon.

Numbers?
								Pavel


> * FIPS-140-3 calls out for cryptographic functions to be non-debuggable (ptrace)
>   meaning that you cannot get to the key material. The solution is the same as
>   above.
> 
> * GPOSPP requires auditing for crypto events (so does FIPS-140 level 2 cert).
>   To do this you need any crypto to have CAP_AUDIT_WRITE permissions which
>   means making everything that links to openssl, libgcrypt, or nss setuid
>   root. Making firefox and 400 other applications setuid root is a non-starter.
>   So, the solution is again to use crypto in the kernel where auditing needs no
>   special permissions.
> 
> Other advantages to having kernel crypto available to user space:
> 
> * User space will be able to take advantage of kernel drivers for hardware
>   crypto accelerators.
> 
> * glibc, which in some configurations links to libfreebl3.so for hashes
>   necessary for crypt(), will be able to use the kernel implementation; this
>   means one less library to load and dynamically link for each such process.
> 
> The code is derived from the original cryptodev-linux patch set; most of the
> new implementation was written by Nikos Mavrogiannopoulos
> <n.mavrogiannopoulos@gmail.com>.  Attributions are included in the respective
> source files.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
