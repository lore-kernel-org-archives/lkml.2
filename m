Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2CJMnp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 07:43:45 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51694 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab2CJMnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 07:43:43 -0500
Date: Sat, 10 Mar 2012 12:45:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Jovi Zhang <bookjovi@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] vt: NULL dereference in vt_do_kdsk_ioctl()
Message-ID: <20120310124522.64fc5851@pyramind.ukuu.org.uk>
In-Reply-To: <20120310085923.GD4647@elgon.mountain>
References: <20120310085923.GD4647@elgon.mountain>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2012 11:59:23 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> We forgot to set the "key_map" variable here, so it's still NULL.  This
> was introduced recently in 079c9534a9 "vt:tackle kbd_table".
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
> index 70d0593..86dd1e3 100644
> --- a/drivers/tty/vt/keyboard.c
> +++ b/drivers/tty/vt/keyboard.c
> @@ -1863,6 +1863,7 @@ int vt_do_kdsk_ioctl(int cmd, struct kbentry __user *user_kbe, int perm,
>  				return -EPERM;
>  			}
>  			key_maps[s] = new_map;
> +			key_map = new_map;
>  			key_map[0] = U(K_ALLOCATED);
>  			for (j = 1; j < NR_KEYS; j++)
>  				key_map[j] = U(K_HOLE);

Eep I thought I got all of those. Well noted

Acked-by: Alan Cox <alan@linux.intel.com>
