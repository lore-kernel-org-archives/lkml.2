Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1EDEpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 00:45:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38802 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab1EDEpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 00:45:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=P3q/LtiLXRDW5M9apfXqtpa0o1NGigAbH1bVHFdu+pPiKJ2tRE+akDw5nhKqNVQehj
         zft90B72mafT9ujrLEIfKmtWkWc6dWOiPnf3AFNPO1vEq5mJfSeBAWo76EfKYtror2gd
         mx3OZe9TRn8uRvt37KE3JCv8K0um3Iwr6Ghg0=
MIME-Version: 1.0
In-Reply-To: <1304458235-28473-1-git-send-email-sven@narfation.org>
References: <1304458235-28473-1-git-send-email-sven@narfation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 4 May 2011 00:44:46 -0400
Message-ID: <BANLkTiminpyJ_opxhqG0E0gBOrF490b+tQ@mail.gmail.com>
Subject: Re: [PATCH] atomic: add *_dec_not_zero
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, x86@kernel.org,
        linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-cris-kernel@axis.com,
        linux-ia64@vger.kernel.org, linux-m32r@ml.linux-m32r.org,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-am33-list@redhat.com, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 17:30, Sven Eckelmann wrote:
> Introduce an *_dec_not_zero operation.  Make this a special case of
> *_add_unless because batman-adv uses atomic_dec_not_zero in different
> places like re-broadcast queue or aggregation queue management. There
> are other non-final patches which may also want to use this macro.
>
> Cc: uclinux-dist-devel@blackfin.uclinux.org
>
> --- a/arch/blackfin/include/asm/atomic.h
> +++ b/arch/blackfin/include/asm/atomic.h
> @@ -103,6 +103,7 @@ static inline int atomic_test_mask(int mask, atomic_t *v)
>        c != (u);                                               \
>  })
>  #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
> +#define atomic_dec_not_zero(v) atomic_add_unless((v), -1, 0)
>
>  /*
>  * atomic_inc_and_test - increment and test

no opinion on the actual idea, but for the Blackfin pieces:
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
