Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab1LELcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:32:36 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46621 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755912Ab1LELcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:32:35 -0500
Date: Mon, 5 Dec 2011 11:34:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: wangyanqing <udknight@gmail.com>
Cc: gregkh@suse.de, amworsley@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:usb:serial:ftdi_sio.c: ftdi_set_termios make no
 sense some in a situation
Message-ID: <20111205113424.6225ddcb@lxorguk.ukuu.org.uk>
In-Reply-To: <20111205074730.GA10142@udknight.homenetwork>
References: <20111205074730.GA10142@udknight.homenetwork>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011 15:47:30 +0800
wangyanqing <udknight@gmail.com> wrote:

> b1ffb4c851f185e9051ba837c16d9b84ef688d26 make a improvement to drop no sense reset
> termios. But it miss the situation, when call ftdi_set_termios with the value that
> same with the default settings all the time, then termios will take no effect any way,
> we need usb_control_msg to make effect. This patch try to resolve this question.
> 
> Signed-off-by: Wang YanQing <ukdnight@gmail.com>
> ---
>  drivers/usb/serial/ftdi_sio.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
> index 486769c..61f1be4 100644
> --- a/drivers/usb/serial/ftdi_sio.c
> +++ b/drivers/usb/serial/ftdi_sio.c
> @@ -2056,6 +2056,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
>  	struct ktermios *termios = tty->termios;
>  	unsigned int cflag = termios->c_cflag;
>  	__u16 urb_value; /* will hold the new flags */
> +	static int init_once = 1;

NACK

Think about what happens if you have two such ports or remove and re-add
it.

What code path is calling set_termios passing a termios data which has
never been set ?

Alan
