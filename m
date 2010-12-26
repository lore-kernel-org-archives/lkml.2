Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab0LZRsy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 12:48:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab0LZRsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 12:48:53 -0500
Date: Sun, 26 Dec 2010 10:49:05 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Tsozik <tsozik@yahoo.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mct_u232: IOCTL implementation
Message-ID: <20101226104905.6801612f@lembas.zaitcev.lan>
In-Reply-To: <985550.24725.qm@web65704.mail.ac4.yahoo.com>
References: <985550.24725.qm@web65704.mail.ac4.yahoo.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Dec 2010 21:39:39 -0800 (PST)
Tsozik <tsozik@yahoo.com> wrote:

> +++ mct_u232.c  2010-12-25 21:44:57.714640343 -0500
> +static int  mct_u232_ioctl(struct tty_struct *tty, struct file *file,
> +                        unsigned int cmd, unsigned long arg)
> +{
> +       case TIOCGICOUNT:
> +                dbg("%s - (%d) TIOCGICOUNT RX=%d, TX=%d", __func__,
> +                    port->number, mct_u232_port->icount.rx, mct_u232_port->icount.tx);
> +                if (copy_to_user((void __user *)arg, &mct_u232_port->icount,
> +                    sizeof(mct_u232_port->icount)))
> +                        return -EFAULT;

This looks suspicious. Didn't we relocate the machinery for TIOCGICOUNT
into a generic place? Please examine how ->get_icount works before
hand-rolling the ioctl.

-- Pete
