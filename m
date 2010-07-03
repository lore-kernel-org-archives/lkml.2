Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab0GCJBF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 05:01:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62585 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab0GCJBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 05:01:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Break out types from <linux/list.h> to <linux/list_types.h>.
Date: Sat, 3 Jul 2010 11:00:43 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <201007021811.04197.arnd@arndb.de> <4C2E3F1F.3010202@tilera.com> <20100702204817.GB5842@parisc-linux.org>
In-Reply-To: <20100702204817.GB5842@parisc-linux.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007031100.43158.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/nKJ6ch5E2FEb2mVYurRL5BoTVig9a70GKuzR
 LFWzCqwejRJk1gCMIpqMC2AYrDKLVUgpqSfYN0XT97YcCtAJDY
 PwghgnLlwMH7RBn9FWlhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 July 2010 22:48:17 Matthew Wilcox wrote:
> I wouldn't mind seeing kvm_types.h, rwlock_types.h and spinlock_types.h
> merged into types.h, personally.  They're all pretty fundamental kernel
> kind of types.  It's a matter of taste, and I'm not particularly fussed
> one way or the other.
> 
> mm_types.h is complex and full of mm-specific information, so keeping
> it separate makes sense to me.
> 
> I just object to the unnecessary creation of tiny files like this.
> Which is how we ended up with atomic_t and atomic64_t in there in the
> first place :-)

Ah, I didn't notice you had moved the atomic types in there. I agree that
the list types are in the same general category and it makes sense
to treat them the same way.

For rwlock_types.h and spinlock_types.h, I think including them in types.h
would really cause too much other crap to be pulled in through lockdep
and other things we might need in there in the future, which would in turn
cause the same problems with types.h that Chris is trying to avoid
in the first place by moving stuff out of list.h.

	Arnd
