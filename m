Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab1DRG4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 02:56:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63493 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab1DRG4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 02:56:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH V14 3/4] ptp: Added a clock driver for the IXP46x.
Date: Mon, 18 Apr 2011 08:56:03 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
References: <cover.1303107532.git.richard.cochran@omicron.at> <dbee2487a57fd7f41e4efbbd2ddfb1313b8d71bc.1303107532.git.richard.cochran@omicron.at>
In-Reply-To: <dbee2487a57fd7f41e4efbbd2ddfb1313b8d71bc.1303107532.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104180856.04186.arnd@arndb.de>
X-Provags-ID: V02:K0:RNlgAGuD02dUOXst3QWNMqT9xVW/Upl2+DrsRHZV7GL
 TpSBk3lcL9/aKKMkJp7+rkrxkmKQJEWzk1BJfdx7d1LDMCXHoW
 l4DXx4hp5cXm0vSN/Fynmppys1fyxgqI5+OaWca2gbB/hvA9h5
 ikQ+cqVPNcstQs7U8r8MNaimxKw6mpwbJMBCKJ6KiRFcQ6BSzc
 g7K4LlSDAR9NlaYwqOeeA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 April 2011, Richard Cochran wrote:
> +static void ixp_rx_timestamp(struct port *port, struct sk_buff *skb)
> +{
> +       struct skb_shared_hwtstamps *shhwtstamps;
> +       struct ixp46x_ts_regs *regs;
> +       u64 ns;
> +       u32 ch, hi, lo, val;
> +       u16 uid, seq;
> +
> +       if (!port->hwts_rx_en)
> +               return;
> +
> +       ch = PORT2CHANNEL(port);
> +
> +       regs = (struct ixp46x_ts_regs __iomem *) IXP4XX_TIMESYNC_BASE_VIRT;
> +
> +       val = __raw_readl(&regs->channel[ch].ch_event);
> +
> +       if (!(val & RX_SNAPSHOT_LOCKED))
> +               return;
> +
> +       lo = __raw_readl(&regs->channel[ch].src_uuid_lo);
> +       hi = __raw_readl(&regs->channel[ch].src_uuid_hi);
> +

I guess you should use readl(), not __raw_readl() here. The __raw_* functions
are not meant for device drivers.

	Arnd
