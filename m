Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab0KOMlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 07:41:17 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:44070 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab0KOMlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 07:41:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=vxa8Par/YL1xbivb6RiwKD3Scr/Btyz21IgO9YuHlsXrrFuAOE8CZxmCt5V5O+hYNY
         IlHJ7lpiNiIP959lnA+cuxVzXMZC3OrTFhtx3ckrpnAREpf+AkZbF3XNqm9GUU4OvPD9
         wZcWaz/vub1F4TBVM5huwItKKNTx/ExM7FvLg=
Date: Mon, 15 Nov 2010 15:40:56 +0300
From: Dan Carpenter <error27@gmail.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Mike Frysinger <vapier@gentoo.org>, Feng Tang <feng.tang@intel.com>,
        Tobias Klauser <tklauser@distanz.ch>, linux-kernel@vger.kernel.org,
        yong.y.wang@intel.com, qi.wang@intel.com, kok.howg.ewe@intel.com,
        andrew.chih.howe.khor@intel.com
Subject: Re: [PATCH v3] EG20T: Update PCH_UART driver to 2.6.36
Message-ID: <20101115124055.GA29030@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
	Alan Cox <alan@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
	Mike Frysinger <vapier@gentoo.org>, Feng Tang <feng.tang@intel.com>,
	Tobias Klauser <tklauser@distanz.ch>, linux-kernel@vger.kernel.org,
	yong.y.wang@intel.com, qi.wang@intel.com, kok.howg.ewe@intel.com,
	andrew.chih.howe.khor@intel.com
References: <4CE126DB.4080500@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE126DB.4080500@dsn.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 09:26:03PM +0900, Tomoya MORINAGA wrote:
> +	spin_lock_irqsave(&port->lock, flags);
> +
> +	uart_update_timeout(port, termios->c_cflag, baud);
> +	rtn = pch_uart_hal_set_line(priv, baud, parity, bits, stb);
> +	if (rtn)

	You need a spin_unlock_irqrestore(&port->lock, flags); here.

> +		return;
> +
> +	/* Don't rewrite B0 */
> +	if (tty_termios_baud_rate(termios))
> +		tty_termios_encode_baud_rate(termios, baud, baud);
> +
> +	spin_unlock_irqrestore(&port->lock, flags);
> +}

regards,
dan carpenter
