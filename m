Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176Ab2K1CVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 21:21:51 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:14464
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763Ab2K1CVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 21:21:50 -0500
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2012 21:21:50 EST
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1de0h1202h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 28 Nov 2012 10:32:42 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
CC: <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 6/6 v6] cpufreq, highbank: add support for highbank
 cpufreq
Message-ID: <20121128023240.GA28170@S2100-06.ap.freescale.net>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354046672-7392-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354046672-7392-7-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1354046672-7392-7-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 02:04:32PM -0600, Mark Langsdorf wrote:
> Highbank processors depend on the external ECME to perform voltage
> management based on a requested frequency. Communication between the
> A9 cores and the ECME happens over the pl320 IPC channel.

...

> +static int hb_voltage_change(unsigned int freq)
> +{
> +	int i;
> +	u32 msg[7];
> +
> +	msg[0] = HB_CPUFREQ_CHANGE_NOTE;
> +	msg[1] = freq / 1000;
> +	for (i = 2; i < 7; i++)
> +		msg[i] = 0;
> +
> +	return pl320_ipc_transmit(msg);

Is it possible to have this handled inside clk_set_rate() call of cpu
clock?

Shawn

> +}

