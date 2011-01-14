Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab1ANQCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:02:37 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57888 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728Ab1ANQCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:02:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sQa0fvHD1Cwzni83x+CD3R5AptOu5hrUYAis+wGz4Kf9qy/I2dOfXMr2pLnDCZY917
         g8UNzHCqV65UnA7OQmRdh8r0PktlXiMHn12fmURCkxRCKIAOjar5zJr1IiGLyQOVdIAk
         miHucJ0B63oikE0/7oY7fjPRksYmqs53XygQ4=
MIME-Version: 1.0
In-Reply-To: <AANLkTin61iqrD0Jbax+cvQ1wxD8b=c4KJv7pBSvU7kbv@mail.gmail.com>
References: <AANLkTin61iqrD0Jbax+cvQ1wxD8b=c4KJv7pBSvU7kbv@mail.gmail.com>
Date: Fri, 14 Jan 2011 18:02:30 +0200
Message-ID: <AANLkTikrCeTNWzGxCx5ZvBbYM09No-f013i5J=nfW3p1@mail.gmail.com>
Subject: Re: Kernel 2.6.37-git10 build failure: cassini.c
From: Anca Emanuel <anca.emanuel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: netdev@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Joe Perches <joe@perches.com>,
        Christoph Egger <siccegge@cs.fau.de>, Jiri Pirko <jpirko@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 10:09 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> drivers/net/cassini.c: In function ‘cas_get_vpd_info’:
> drivers/net/cassini.c:3358: error: implicit declaration of function
> ‘of_get_property’
> drivers/net/cassini.c:3358: warning: assignment makes pointer from
> integer without a cast
> drivers/net/cassini.c: In function ‘cas_init_one’:
> drivers/net/cassini.c:5035: error: implicit declaration of function
> ‘pci_device_to_OF_node’
> drivers/net/cassini.c:5035: warning: assignment makes pointer from
> integer without a cast
> make[3]: *** [drivers/net/cassini.o] Error 1
> make[2]: *** [drivers/net] Error 2
>
>
> The first part can be solved with:
>
> diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
> index 7206ab2..fe3795e 100644
> --- a/drivers/net/cassini.c
> +++ b/drivers/net/cassini.c
> @@ -94,6 +94,7 @@
>  #include <linux/tcp.h>
>  #include <linux/mutex.h>
>  #include <linux/firmware.h>
> +#include <linux/of.h>
>
>  #include <net/checksum.h>
>

The second part it's a little bit harder, because:
http://lxr.linux.no/linux+v2.6.37/+search=pci_device_to_OF_node
there is no generic function, only microblaze, powerpc and sparc are
there as users.

Still not solved in git11.
I'm testing this from x86, Ubuntu 10.10 standard config.
