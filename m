Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab2EZCp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 22:45:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61223 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2EZCpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 22:45:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120525111152.7239.99793.stgit@bob.linux.org.uk>
References: <20120525111152.7239.99793.stgit@bob.linux.org.uk>
Date: Sat, 26 May 2012 10:45:55 +0800
Message-ID: <CACVXFVPh5W+a5hr4uVPZRP8GyEEFz86-FH5mp2R5=rCjgmcXAg@mail.gmail.com>
Subject: Re: [PATCH] tty: remove recursive implementation of tty_ldisc_release
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: levinsasha928@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 7:11 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> From: Alan Cox <alan@linux.intel.com>
>
> We need to do this in one pass with the locking requirements we now
> have.
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>
>  drivers/tty/tty_ldisc.c |   40 +++++++++++++++++++++++-----------------
>  1 files changed, 23 insertions(+), 17 deletions(-)
>
>
> diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
> index 833e851..ecfaef5 100644
> --- a/drivers/tty/tty_ldisc.c
> +++ b/drivers/tty/tty_ldisc.c
> @@ -894,6 +894,23 @@ int tty_ldisc_setup(struct tty_struct *tty, struct tty_struct *o_tty)
>        tty_ldisc_enable(tty);
>        return 0;
>  }
> +
> +static int tty_ldisc_kill(struct tty_struct *tty)

Maybe the return type should be defined as void to avoid compile warning.


After applying Alan's three patches for addressing tty locks and the patch
int the below link:

     http://marc.info/?l=linux-kernel&m=133775308420817&w=2

Looks no lockdep warnings are triggered any more when running
'exit' in shell of ssh session.

So I will send out the formal patch in the above link.

Thanks,
-- 
Ming Lei
