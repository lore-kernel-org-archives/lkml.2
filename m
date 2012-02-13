Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2BMDAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 22:00:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55593 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab2BMDAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 22:00:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH resend] asm/types.h: All architectures use int-ll64.h in kernelspace
Date: Mon, 13 Feb 2012 02:59:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
References: <alpine.DEB.2.00.1108132152050.18053@ayla.of.borg> <1665974.2LGtkbyJmJ@wuerfel> <20120211094444.GL23916@ZenIV.linux.org.uk>
In-Reply-To: <20120211094444.GL23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202130259.33347.arnd@arndb.de>
X-Provags-ID: V02:K0:4XhsWMSqOfLMAN1pmCFBh+Oyo22hfXrKLyXDXq+EAEt
 yXzTqV+JIH/JHklXCiKh5YQxZt4g5RUFG9BpYwOuzWDkJUa4gp
 tglsh2MzC/HdAUm2qmvcgHpX9uEaXlHm6RWtWdCzuoZa7Gc1vj
 OQCo4bgzldPcIqtvpXh9mNNn/YJGj7ol7DKp30dNR/ZPzR0NJ8
 Du3S9eUIHxp+TLHAsdDsEzXebOhOt6SangywNKb+vIbQRgWPK+
 tNwiOgTPTFxe8/zniG0DYrmrL/op4y1zCmYcpctV4p9pPJg+7R
 c2bPTpsSaXJZk2thI//jCdriiOpkPnEHpI8gE7l67FVlq0DDph
 kAlUPn4DCwonwkZld+Hw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 February 2012, Al Viro wrote:

> Umm...  That has happened and yes, asm-generic/types.h is currently
> equivalent to asm-generic/int-ll64.h.  What exactly are you planning
> to do?  Just rename the latter to the former and do search-and-replace
> over the tree?  We still have places that pull int-l64.h, albeit only
> !__KERNEL__ ones (i.e. everything under #ifdef __KERNEL__ in there
> seems to be killable)...
> 
> AFAICS, for quite a few of those guys we can simply add bitsperlong.h
> and add types.h to generic-y; is that the plan?

Yes, I think both would be good cleanups. Maybe David Howells can comment
as well since his user api split is going to change that a bit:
We end up needing only a separate version of uapi/asm/types.h for
alpha/ia64/mips64/powerpc64, while the in-kernel file is ok.

	Arnd
