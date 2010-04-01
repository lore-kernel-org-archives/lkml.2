Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab0DAS41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 14:56:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523Ab0DAS4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 14:56:24 -0400
Date: Thu, 1 Apr 2010 11:56:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Timo Witte <timo.witte@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>
Subject: Re: [PATCH] /fs/cifs HEAD
Message-Id: <20100401115620.41821f7d.akpm@linux-foundation.org>
In-Reply-To: <a3177ec71003290139w3f435bddv25e06a576afabb07@mail.gmail.com>
References: <a3177ec71003290139w3f435bddv25e06a576afabb07@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010 10:39:12 +0200
Timo Witte <timo.witte@googlemail.com> wrote:

> commit 4baf102b1db4ba5c91532acf84acdb9c31867fe6
> Author: Timo Witte <timo.witte@googlemail.com>
> Date: __ Mon Mar 29 10:20:09 2010 +0200
> ____ __added additional info to error message in cifs
> diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
> index 8794814..28b588c 100644
> --- a/fs/cifs/dns_resolve.c
> +++ b/fs/cifs/dns_resolve.c
> @@ -137,7 +137,7 @@ dns_resolve_server_name_to_ip(const char *unc,
> char **ip_addr)
>        len = rkey->type_data.x[0];
>        data = rkey->payload.data;
>    } else {
> -        cERROR(1, ("%s: unable to resolve: %s", func, name));
> +       cERROR(1, ("%s: unable to resolve: %s have you
> installed /sbin/request-key ?", func, name));
>        goto out;
>    }

OK, I can see how that would save someone a lot of time.


Your patch did basically everything wrong: meaningless title,
wordwrapped, changelog doesn't explain the reason for making the patch,
missing Signed-off-by:, didn't cc: the maintainer, gmail-inserted
non-ascii chanracters, tabs replaced by spaces (gmail again).

I typed it in again ;)


Subject: cifs: provide user with a hint when name resolution fails

From: Timo Witte <timo.witte@googlemail.com>

Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/dns_resolve.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/cifs/dns_resolve.c~cifs-provide-user-with-a-hint-when-name-resolution-fails fs/cifs/dns_resolve.c
--- a/fs/cifs/dns_resolve.c~cifs-provide-user-with-a-hint-when-name-resolution-fails
+++ a/fs/cifs/dns_resolve.c
@@ -138,7 +138,8 @@ dns_resolve_server_name_to_ip(const char
 		len = rkey->type_data.x[0];
 		data = rkey->payload.data;
 	} else {
-		cERROR(1, ("%s: unable to resolve: %s", __func__, name));
+		cERROR(1, ("%s: unable to resolve: %s have you "
+			"installed /sbin/request-key ?", __func__, name));
 		goto out;
 	}
 
_

