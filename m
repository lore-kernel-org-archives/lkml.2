Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732Ab2EVDbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 23:31:35 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:59053 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758792Ab2EVDbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 23:31:34 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944hd25hf0ah)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 22 May 2012 11:35:02 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>
Subject: Re: [PATCH RFC v2 2/2] pinctrl: add pinctrl gpio binding support
Message-ID: <20120522033501.GB27055@shlinux2.ap.freescale.net>
References: <1337346755-8761-1-git-send-email-b29396@freescale.com>
 <1337346755-8761-2-git-send-email-b29396@freescale.com>
 <4FB6AB9A.4080006@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FB6AB9A.4080006@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 04:05:46AM +0800, Stephen Warren wrote:
...
> > +			np_gpio = of_find_node_by_phandle(phandle);
> > +			if (!np_gpio) {
> > +				dev_err(pctldev->dev,
> > +					"failed to find gpio node(%s)\n",
> > +					np_gpio->name);
> 
> Perhaps devm_kfree(ranges) here so that if this is called multiple times
> due to deferred probe, the allocations from the failed attempts don't
> accumulate. Same for other error paths.
> 
I checked a bit more, it seems the resource will be removed first if there's
a deffer probe error.
static int really_probe(struct device *dev, struct device_driver *drv)
{
.....
probe_failed:
        devres_release_all(dev);
        driver_sysfs_remove(dev);
        dev->driver = NULL;

        if (ret == -EPROBE_DEFER) {
                /* Driver requested deferred probing */
                dev_info(dev, "Driver %s requests probe deferral\n", drv->name);
                driver_deferred_probe_add(dev);
		...
	}
So we may not need devm_kfree for the EPROBE_DEFER error here.
It looks to me reasonable that managed resource covers the defer probe
error.

Regards
Dong Aisheng

