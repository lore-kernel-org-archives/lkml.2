Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2DCQxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 12:53:49 -0400
Received: from sous-sol.org ([216.99.217.87]:45029 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753846Ab2DCQxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 12:53:48 -0400
Date: Tue, 3 Apr 2012 09:53:20 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH-v3] Support M95040 SPI EEPROM
Message-ID: <20120403165320.GG19952@sequoia.sous-sol.org>
References: <1333434302-14897-1-git-send-email-meltedpianoman@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333434302-14897-1-git-send-email-meltedpianoman@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ivo Sieben (meltedpianoman@gmail.com) wrote:
> +	instr = AT25_READ;
> +	if (at25->chip.flags & EE_INSTR_BIT3_IS_ADDR)
> +		if (offset >= (1U << (at25->addrlen * 8)))
> +			instr |= AT25_INSTR_BIT3;
> +	*cp++ = instr;
<snip>
> +	/*
> +	 * Certain EEPROMS have a size that is larger than the number of address
> +	 * bytes would allow (e.g. like M95040 from ST that has 512 Byte size
> +	 * but uses only one address byte (A0 to A7) for addressing.) For
> +	 * the extra address bit (A8, A16 or A24) bit 3 of the instruction byte
> +	 * is used. This instruction bit is normally defined as don't care for
> +	 * other AT25 like chips.
> +	 */
> +#define EE_INSTR_BIT3_IS_ADDR	0x0010

Is there some guarantee that this chip flag will always have this
meaning?

thanks,
-chris
