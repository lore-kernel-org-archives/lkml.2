Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab2K1OcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:32:17 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:38956
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754781Ab2K1OcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:32:15 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1de0h1202h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 28 Nov 2012 22:58:02 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 6/6 v6] cpufreq, highbank: add support for highbank
 cpufreq
Message-ID: <20121128145759.GB28170@S2100-06.ap.freescale.net>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354046672-7392-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354046672-7392-7-git-send-email-mark.langsdorf@calxeda.com>
 <20121128023240.GA28170@S2100-06.ap.freescale.net>
 <50B60E9C.9000405@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50B60E9C.9000405@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 07:16:12AM -0600, Mark Langsdorf wrote:
> Standard practice is to have cpufreq_set_target() handle voltage
> transitions and leave clk_set_rate() handle the frequency changes.

The standard practice is to have cpufreq_set_target() handle both
voltage and frequency transitions, while voltage is handled by regulator
and frequency by clk API.

> I'd
> have to move most of the logic of hb_set_target() into
> clk_highbank.c:clk_pll_set_rate() and then add extra logic for when
> cpufreq is not enabled/loaded.

You only need to move hb_voltage_change() into cpu clock's .set_rate()
hook with no need of checking if cpufreq is enabled or not.

> I don't think the clk maintainers would
> take that patch, either.

This is all handled platform clock specific .set_rate() hook.  I doubt
it will concern clk maintainers at all, especially when doing so we
will avoid another cpufreq driver by just using cpufreq-cpu0 driver.

Shawn

