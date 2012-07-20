Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab2GTNxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 09:53:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59973 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab2GTNxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 09:53:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] MPILIB: Provide count_leading/trailing_zeros() based on arch functions
Date: Fri, 20 Jul 2012 13:53:33 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
References: <20120720125657.15422.12922.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120720125657.15422.12922.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207201353.34324.arnd@arndb.de>
X-Provags-ID: V02:K0:x1O9+URUVQPNcC7Lz6AltO9oai8zlZNyyEeXIrikNX4
 yd26RXmNAuybgYT0achPkpwIhWv6mZ3A5Byle5+YbU0Doy49rb
 kRmdUJBskUZ9XtIg9UOA1jMOcnYY8+inLteYM5WC1JFi8NPITS
 wDv0IMyBMtu9TOmt9B9TYugNTH7iNXAltsruSxd9PvIGOJR2cq
 vddqbGzxzuF720q+AqHOU742i6XxO/lPmc5MckAv4pYvcmgwU8
 pDMrU/8DjmwUItEoEXvlRQKCDHsriyYQSL9TZb5Dck/nG3+zuc
 Ug7kPhd71usKiLrsiku9tKWTjHDu1zNjCllyHvr1K70wOpQuXp
 IMhq1ZYEEgv8sr3mmnX4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2012, David Howells wrote:
> Provide count_leading/trailing_zeros() macros based on extant arch bit scanning
> functions rather than reimplementing from scratch in MPILIB.
> 
> Whilst we're at it, turn count_foo_zeros(n, x) into n = count_foo_zeros(x).
> 
> Also move the definition to asm-generic as other people may be interested in
> using it.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> Cc: Arnd Bergmann <arnd@arndb.de>

I don't generally like to put stuff into asm-generic when it's unlikely
to be overridden by architectures. It would really belong into
include/linux, but then again we have all the other bitops in asm-generic
as well, so whatever...

Acked-by: Arnd Bergmann <arnd@arndb.de>
