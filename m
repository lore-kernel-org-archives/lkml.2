Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1CWVqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:46:40 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:44027 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab1CWVqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:46:38 -0400
Subject: Re: [PATCH V12 4/4] ptp: Added a clock driver for the National
 Semiconductor PHYTER.
From: John Stultz <john.stultz@linaro.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <f8af215ebe32a8c0f4b3a82b8ee7e8008b4feb1e.1298878618.git.richard.cochran@omicron.at>
References: <cover.1298878618.git.richard.cochran@omicron.at>
	 <f8af215ebe32a8c0f4b3a82b8ee7e8008b4feb1e.1298878618.git.richard.cochran@omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 14:46:25 -0700
Message-ID: <1300916785.848.54.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 08:58 +0100, Richard Cochran wrote:
> This patch adds support for the PTP clock found on the DP83640.
> The basic clock operations and one external time stamp have
> been implemented.

Just locking rule comment nits here.

> +static int tdr_write(int bc, struct phy_device *dev,
> +		     const struct timespec *ts, u16 cmd)
> +{
> +	ext_write(bc, dev, PAGE4, PTP_TDR, ts->tv_nsec & 0xffff);/* ns[15:0]  */
> +	ext_write(bc, dev, PAGE4, PTP_TDR, ts->tv_nsec >> 16);   /* ns[31:16] */
> +	ext_write(bc, dev, PAGE4, PTP_TDR, ts->tv_sec & 0xffff); /* sec[15:0] */
> +	ext_write(bc, dev, PAGE4, PTP_TDR, ts->tv_sec >> 16);    /* sec[31:16]*/
> +
> +	ext_write(bc, dev, PAGE4, PTP_CTL, cmd);
> +
> +	return 0;
> +}

The above needs to hold the extreg_lock, and should be commented as
such.

And again, the function names are sort of generic, and could use a
dp83640_ prefix or something.

thanks
-john


