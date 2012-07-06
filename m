Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab2GFVYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:24:35 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55697 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756391Ab2GFVYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:24:32 -0400
X-Sasl-enc: 131x4VZm9GW4S9KvWvldutljvgcOZct5ppugK5XaLQ4z 1341609871
Date: Fri, 6 Jul 2012 14:24:30 -0700
From: Greg KH <greg@kroah.com>
To: Shachar Shemesh <shachar@liveu.tv>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Subject: [PATCH] tty ldisc: Close/Reopen race prevention should
 check the proper flag
Message-ID: <20120706212430.GA454@kroah.com>
References: <4FEFF3DF.9000909@liveu.tv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEFF3DF.9000909@liveu.tv>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 09:53:19AM +0300, Shachar Shemesh wrote:
> From: Shachar Shemesh <shachar@liveu.tv>
> 
> Commit acfa747b introduced the TTY_HUPPING flag to distinguish
> closed TTY from currently closing ones. The test in tty_set_ldisc
> still remained pointing at the old flag. This causes pppd to
> sometimes lapse into uninterruptible sleep when killed and
> restarted.
> 
> Signed-off-by: Shachar Shemesh <shachar@liveu.tv>
> ---
> Tested with 3.2.20 kernel.
> 
> diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
> index 24b95db..a662a24 100644
> --- a/drivers/tty/tty_ldisc.c
> +++ b/drivers/tty/tty_ldisc.c
> @@ -658,7 +658,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
>          goto enable;
>      }
> 
> -    if (test_bit(TTY_HUPPED, &tty->flags)) {
> +    if (test_bit(TTY_HUPPING, &tty->flags)) {

All tabs are converted to spaces and make this patch impossible to apply
:(

Care to try again?

greg k-h
