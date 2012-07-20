Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab2GUItA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 04:49:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51451 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2GUIs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 04:48:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] MPILIB: Provide count_leading/trailing_zeros() based on arch functions
Date: Fri, 20 Jul 2012 22:02:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
References: <201207201353.34324.arnd@arndb.de> <20120720125657.15422.12922.stgit@warthog.procyon.org.uk> <5723.1342794099@warthog.procyon.org.uk>
In-Reply-To: <5723.1342794099@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207202202.28723.arnd@arndb.de>
X-Provags-ID: V02:K0:JOk0jdp6bPq/iL3oKpv7rmN2gHyKpGi8v0LnQsS0cGo
 IV+BuebbZl5OLQbnSJu1nI3M3sO3NoUSQzHApoFSiA5QZXW33P
 hngX4t4yySU61NMzfIC0szz3KUQS6Os8jlHO+14zVWw8mzPRTO
 Tnqv71BF5hz4Sw5aNoDW/Ee4ntlQRjrC5Z6Ng6nJipCSK+iMqm
 tqh4oQzDEeieR5R7EsJDUy+FRDMCF1IormXfHmZdxWcLzAnnmI
 mj4+tOh/A9WCtV5DhLsQsyorx64pylscHTx74KaVH5Pf7jvkZ0
 QzH+M5Vd5mbca00+o37hWlM8bPsJBbb9uO2AfA6uM5vNA/d9GJ
 EZkfyumCiRR4VOEGsIMk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2012, David Howells wrote:
> 
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > I don't generally like to put stuff into asm-generic when it's unlikely
> > to be overridden by architectures. It would really belong into
> > include/linux, but then again we have all the other bitops in asm-generic
> > as well, so whatever...
> 
> Some arches (such as Sparc, I think) have count-leading-zero instructions.

But I guess they would still use the same definition of

+static inline int count_leading_zeros(unsigned long x)
+{
+       if (sizeof(x) == 4)
+               return BITS_PER_LONG - fls(x);
+       else
+               return BITS_PER_LONG - fls64(x);
+}

and just provide their own fls().

	Arnd
