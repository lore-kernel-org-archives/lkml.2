Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965239Ab1GMKJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 06:09:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34646 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964996Ab1GMKJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 06:09:04 -0400
MIME-Version: 1.0
In-Reply-To: <1310549424-5484-1-git-send-email-arend@broadcom.com>
References: <1310549424-5484-1-git-send-email-arend@broadcom.com>
Date: Wed, 13 Jul 2011 13:09:03 +0300
Message-ID: <CACVxJT-TXBd5S+HNfzNR2hnGUk2hMfTSQrkodUunUXOQ6+X8eg@mail.gmail.com>
Subject: Re: [PATCH] net: change return values in mac_pton() function
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 12:30 PM, Arend van Spriel <arend@broadcom.com> wrote:
> The original commit adding this function noted a diverge from usual
> 0=success/-E=fail, but no motivation for it.

I thought it was obvious, but indeed wasn't explicitely
mentioned in changelog. But see inet_pton(3).

> To stay consistent this
> commit adheres to the usual approach. The callers check for result
> is changed from 'if(!mac_pton(x, y))' to 'if(mac_pton(x,y) < 0)'.

> @@ -304,20 +304,20 @@ int mac_pton(const char *s, u8 *mac)
>
>        /* XX:XX:XX:XX:XX:XX */
>        if (strlen(s) < 3 * ETH_ALEN - 1)
> -               return 0;
> +               return -EINVAL;
