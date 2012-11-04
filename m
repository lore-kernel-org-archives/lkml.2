Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab2KDTkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 14:40:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:59034 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab2KDTkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 14:40:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: Re: [PATCH] drivers/misc/kgdbts.c: remove eprintk
Date: Sun, 4 Nov 2012 19:39:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: walter harms <wharms@bfs.de>, kernel-janitors@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr> <509509F8.2010407@bfs.de> <alpine.DEB.2.02.1211031525500.1955@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1211031525500.1955@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211041939.51608.arnd@arndb.de>
X-Provags-ID: V02:K0:9Iva78VrufVjMbYsWsJF5HnN9LTwfnuIF6sTtpOATj5
 r4A5+r+kzKhEcb7kdBZhYwDz28TBfHUu6Gily8V2EWzBIdLE8K
 A61Jt+9m3+tqdEcQ1/Nk7zAieEzO86ZijaFqvTMNz/SQwHb67f
 NtX4YTQEVzG7PiPTEKxmm56mcXs66AE1DksoA4iLn+Xjqrks82
 vhL/B2HsvwwQQ8/w2pluQNG3xxBqWzcH9ajxLniPMLDwfvMRP+
 b/GuPvQ+PzMqCfC0njBYu/17LkF736evcg3uoN3PdXPFKS6BdV
 ETyJ2VE4mBwkzXfMsCUniIfVOXWOWAlgnI7H4bvya2R1GY4sRa
 oyK0i4rqM5b8JlRfawU0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 November 2012, Julia Lawall wrote:
> @@ -113,10 +113,6 @@
>                 printk(KERN_INFO a); \
>                 touch_nmi_watchdog();   \
>         } while (0)
> -#define eprintk(a...) do { \
> -               printk(KERN_ERR a); \
> -               WARN_ON(1); \
> -       } while (0)
>   #define MAX_CONFIG_LEN                40
> 
>   static struct kgdb_io kgdbts_io_ops;
> @@ -323,7 +319,7 @@ static int check_and_rewind_pc(char *put_str, char *arg)
>                 v2printk("Emul: rewind hit single step bp\n");
>                 restart_from_top_after_write = 1;
>         } else if (strcmp(arg, "silent") && ip + offset != addr) {
> -               eprintk("kgdbts: BP mismatch %lx expected %lx\n",
> +               WARN(1, KERN_ERR "kgdbts: BP mismatch %lx expected %lx\n",
>                            ip + offset, addr);
>                 return 1;
>         }

Hmm, I did not think that WARN() took a KERN_ERR argument, which should
really be implied here. Looking at the code, it really seems to be required
at the moment, but only 5 out of 117 callers use it this way.

Any idea what is going on here?

	Arnd
