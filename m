Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0CaEhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 00:37:17 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:6767 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab0CaEhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 00:37:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f6cw6TeNUTeS8druBWc0IoDS3PghCOXDKn0jnac2sy0YfiypGcEe/00Taqu8MVNasv
         7xP6BOURA/gb2ztH5uRSq4f4Es4nxTUReU1+GFNqHIcA7gvOQ6CFZ5cu1yevLUtQKOyn
         tv7DftRMswU+BQuTyQ/QzUbG3SmJ2lgA16Aw8=
MIME-Version: 1.0
In-Reply-To: <1269982580-9361-8-git-send-email-arnd@arndb.de>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de>
	 <1269982580-9361-8-git-send-email-arnd@arndb.de>
Date: Wed, 31 Mar 2010 12:37:12 +0800
Message-ID: <2375c9f91003302137x7753a744pb2d2f0655738c7e4@mail.gmail.com>
Subject: Re: [RFC 7/9] ppp: use big tty mutex
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 4:56 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> ppp interacts with the tty layer, so it should
> take the BTM instead of the BKL.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ppp_generic.c |   29 +++++++++++++++--------------
>  1 files changed, 15 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
> index 6d61602..bc89a1b 100644
> --- a/drivers/net/ppp_generic.c
> +++ b/drivers/net/ppp_generic.c
> @@ -40,7 +40,7 @@
>  #include <linux/if_arp.h>
>  #include <linux/ip.h>
>  #include <linux/tcp.h>
> -#include <linux/smp_lock.h>
> +#include <linux/tty.h>
>  #include <linux/spinlock.h>
>  #include <linux/rwsem.h>
>  #include <linux/stddef.h>
> @@ -362,7 +362,8 @@ static const int npindex_to_ethertype[NUM_NP] = {
>  */
>  static int ppp_open(struct inode *inode, struct file *file)
>  {
> -       cycle_kernel_lock();
> +       tty_lock();
> +       tty_unlock();

I don't really get your point here. :) Why do you do this?
