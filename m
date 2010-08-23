Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab0HWCaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 22:30:13 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40079 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab0HWCaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 22:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pJKAkVvKMTUZh9Ks2qpwGfzxc2l+hEszty92rUEG3AulJraLVohhjL/+Z6jCTx5VUM
         IKfTvLtfre9LnX5nwszlR83G7n5+lW66zc6dkz7gRiCMPJs86N7BNdQmHch7qHHgf7+D
         JruJGjsohFLdhJTDLMt8VaGjIrSVVi708Ahaw=
MIME-Version: 1.0
In-Reply-To: <20100822.183624.28802617.davem@davemloft.net>
References: <AANLkTin1BOgHBc4sTwFAmQhKFNvZ+90herc4Dsh9P8y2@mail.gmail.com>
 <201008221507.42023.arnd@arndb.de> <AANLkTiktOcAvAxcXUxh+4jKh0nBmYCf0OVG0wqRNMb9T@mail.gmail.com>
 <20100822.183624.28802617.davem@davemloft.net>
From: Changli Gao <xiaosuo@gmail.com>
Date: Mon, 23 Aug 2010 10:29:49 +0800
Message-ID: <AANLkTikBcuYa_HNzhYYG62CLjcfptQNQM_zOsv9fXRfS@mail.gmail.com>
Subject: Re: [PATCH] net: define __packed for the userspace code
To: David Miller <davem@davemloft.net>
Cc: arnd@arndb.de, eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 9:36 AM, David Miller <davem@davemloft.net> wrote:
>
> I don't think this it the reason it was being used here.
>
> Any, for one thing, we definitely cannot remove the existing packed
> markers or else we will break every single userland tool out there
> using these socket address structures.
>
> Even the first two members (sa_family_t and unsigned int) will be
> positioned differently if we remove the marker.
>
> I suspect the packed attribute is there to make sure the pppo* socket
> address structures fit within the generic socket address object size.
> (see struct __kernel_sockaddr_storage and struct sockaddr).
>
> As to the problem at-hand, I think we need to use __attribute__((packed))
> here.  And that's what I'll commit into net-2.6 and net-next-2.6
>

Do you mean that use the __attribute__((packed)) annotation in all of
these files:

localhost linux # grep "\<__packed\>" usr/include/ -r | uniq
usr/include/linux/if_hippi.h:} __packed;
usr/include/linux/if_fddi.h:} __packed;
usr/include/linux/nbd.h:} __packed;
usr/include/linux/ncp.h:} __packed;
usr/include/linux/rfkill.h:} __packed;
usr/include/linux/if_pppox.h:} __packed;
usr/include/linux/phonet.h:} __packed;
usr/include/linux/ipv6.h:} __packed;    /* required for some archs */
usr/include/linux/ipv6.h:} __packed;
usr/include/linux/if_ether.h:} __packed;

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
