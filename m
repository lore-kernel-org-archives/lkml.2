Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab2KKB1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 20:27:45 -0500
Received: from nm29-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.255]:44594
	"EHLO nm29-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751578Ab2KKB1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 20:27:41 -0500
X-Yahoo-Newman-Id: 336199.67138.bm@smtp114.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: yiSEhqYVM1nBgwW31lEYGVedtJz4BlktsHcaMnIpnyM9V31
 l1pKzYiPUbryiDvYSW4ixn6JiifqRYaxpDWgQUC1ikb1mGXfCPunXoSU_2jA
 aCt27a0qqggphpt8S2a9gi_tKpbAo5q6hsuYWqrsIclIoGGihOQ34lfQr7Q1
 NddFZF.F5SHKiva49BVa27q04g.okWpVDL3aR0AkhPvaz0G8O.LvElBPzGsN
 uf_WG91sHFlKbhZ7jmz8A4Pt_soLUwrX7glX4EzaVbAXiEU_D02u_MWALSQ2
 PqfMQqa3_fzCEMaHhyN0c8q6Cgmq7oq8hOmYh_7SxskmRLFDLHgy8jcX5n5i
 wXdPMt3OZd9dAetdwjdMfvlidRMjspDMERWUmP2ds6WEuVZW9uyKYc59WpxB
 BeKLpEhuGPRu4KWgPiIJvKU7NmzDdCLo_UumR.yKqF0ROTAq8X.AlPysXdrz
 KJtF1tDoFwXmvz3226Yb8nA--
X-Yahoo-SMTP: x3UJDw2swBBmiVP7941KaiyaoilgwM.0jf7QxQtKIw--
Message-ID: <509EFDA3.4060900@pacbell.net>
Date: Sat, 10 Nov 2012 17:21:39 -0800
From: Richard <richjunk@pacbell.net>
Reply-To: richjunk@pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120919 Thunderbird/15.0.1
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH usb-linus] USB: keyspan: fix typo causing GPF on open
References: <509D5BCD.3010901@pacbell.net> <1352538822-28221-1-git-send-email-bjorn@mork.no>
In-Reply-To: <1352538822-28221-1-git-send-email-bjorn@mork.no>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjørn:

I patched keyspan.c using your below supplied diff in 3.6.6 (I'm not
using git.)  The patch WORKS for me.  (I tested using minicom and the
two programs that usually access the Keyspan serial device.)

Thank you for the quick fix.

Will this show up in 3.6.7?

Richard
richjunk@pacbell.net


On 11/10/2012 01:13 AM, Bjørn Mork wrote:
> Commit f79b2d0f (USB: keyspan: fix NULL-pointer dereferences and
> memory leaks) had a small typo which made the driver use wrong
> offsets when mapping serial port private data.  This results in
> in a GPF when the port is opened.
> 
> Reported-by: Richard <richjunk@pacbell.net>
> Cc: <stable@vger.kernel.org>
> Cc: Johan Hovold <jhovold@gmail.com>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> ---
> Hello Richard,
> 
> I wonder if you are able to test and verify this?  I do not guarantee
> that there aren't other issues around, but this small typo looked like
> an obvious killer...
> 
> Bjørn
> 
>  drivers/usb/serial/keyspan.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
> index 7179b0c..cff8dd5 100644
> --- a/drivers/usb/serial/keyspan.c
> +++ b/drivers/usb/serial/keyspan.c
> @@ -2430,7 +2430,7 @@ static void keyspan_release(struct usb_serial *serial)
>  static int keyspan_port_probe(struct usb_serial_port *port)
>  {
>  	struct usb_serial *serial = port->serial;
> -	struct keyspan_port_private *s_priv;
> +	struct keyspan_serial_private *s_priv;
>  	struct keyspan_port_private *p_priv;
>  	const struct keyspan_device_details *d_details;
>  	struct callbacks *cback;
> @@ -2445,7 +2445,6 @@ static int keyspan_port_probe(struct usb_serial_port *port)
>  	if (!p_priv)
>  		return -ENOMEM;
>  
> -	s_priv = usb_get_serial_data(port->serial);
>  	p_priv->device_details = d_details;
>  
>  	/* Setup values for the various callback routines */
> 
