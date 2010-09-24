Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab0IXRqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:46:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54768 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab0IXRqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=S26rNoyv5TiA6YG/IiC2eBT70JQMsZydxadJAxT2qgjz96zQBbqAO1dP7kA4F5Rmkj
         5lP9Cxt1n5A4ItG2dULDG5+QVIxKY7CuH7BnQPL4EunJert0xpJCGs/EPhI1EZ021cBp
         ZCJlC+DEyTl60YLyRzgvF3d0ToUpx5UIRCA6o=
Subject: Re: [PATCH 2/5] AF_UNIX: enable/disable multicast with
 getsockopt/setsockopt
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alban Crequy <alban.crequy@collabora.co.uk>
Cc: "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Ian Molton <ian.molton@collabora.co.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dbus@freedesktop.org
In-Reply-To: <1285349116-17529-2-git-send-email-alban.crequy@collabora.co.uk>
References: <20100924182257.11abd9a6@chocolatine.cbg.collabora.co.uk>
	 <1285349116-17529-2-git-send-email-alban.crequy@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 19:46:28 +0200
Message-ID: <1285350388.2478.0.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 24 septembre 2010 à 18:25 +0100, Alban Crequy a écrit :
> Multicast can be enabled or disabled after a socket is allocated but this
> cannot be changed once the socket is bound or connected.
> 
> Userspace applications can enable multicast on an Unix stream socket:
>   sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
>   #define UNIX_MULTICAST 1
>   val = 1;
>   len = sizeof(val);
>   ret = setsockopt(sockfd, 0, UNIX_MULTICAST, &val, len);
> 
> Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>


> +		if (val != 0) {
> +			u->multicast = 1;
> +		} else {
> +			u->multicast = 0;
> +		}

u->multicast = !!val;



