Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab0KRNif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:38:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36007 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab0KRNie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:38:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WwdzUMkJ1YOMwJ9FUIoSl99FbHysCnXO6e51L3VDGLL+gm2YGaWyDjeeCBT+ngpbXI
         T9xfCOwh0LtacPI11eFlGUTPsEZUM3SZ3HlBBCAIvGqnh0qBXcMCyy6J1o6OG86DfRYq
         3eNC0jEKRUfirqbmMehaDSSd8b5nK0ganc+8U=
Subject: Re: [PATCH 1/2] perf: Fix compilation on gcc 4.0.2
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, acme@redhat.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
In-Reply-To: <20101118133112.GC12667@basil.fritz.box>
References: <1290077461-12321-1-git-send-email-andi@firstfloor.org>
	 <1290077461-12321-2-git-send-email-andi@firstfloor.org>
	 <1290078937.2109.1345.camel@laptop>
	 <20101118133112.GC12667@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 14:38:09 +0100
Message-ID: <1290087489.2781.121.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 18 novembre 2010 à 14:31 +0100, Andi Kleen a écrit :
> > Should we be using more of the kernel makefile magic to detect this?
> 
> In theory yes, but the two warnings didn't seem to be too useful
> to me so it's probably not worth it just for those two.
> 
> -Andi
> 

Is the second case because of the __always_inline in
util/include/linux/bitops.h ?

Not sure why its needed for test_bit() ?

diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index bb4ac2e..a1459f2 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -13,7 +13,7 @@ static inline void set_bit(int nr, unsigned long *addr)
 	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
 }
 
-static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
+static inline int test_bit(unsigned int nr, const unsigned long *addr)
 {
 	return ((1UL << (nr % BITS_PER_LONG)) &
 		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;


