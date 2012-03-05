Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab2CEH6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 02:58:35 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:54105
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755914Ab2CEH6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 02:58:34 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 5 Mar 2012 16:03:02 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 4/7] pinctrl: API changes to support multiple states
 per device
Message-ID: <20120305080301.GB21987@shlinux2.ap.freescale.net>
References: <1330718750-15217-1-git-send-email-swarren@nvidia.com>
 <1330718750-15217-5-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1330718750-15217-5-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2012 at 04:05:47AM +0800, Stephen Warren wrote:
> The API model is changed from:
> 
> p = pinctrl_get(dev, "state1");
> pinctrl_enable(p);
> ...
> pinctrl_disable(p);
> pinctrl_put(p);
> p = pinctrl_get(dev, "state2");
> pinctrl_enable(p);
> ...
> pinctrl_disable(p);
> pinctrl_put(p);
> 
> to this:
> 
> p = pinctrl_get(dev);
> s1 = pinctrl_lookup_state(p, "state1");
> s2 = pinctrl_lookup_state(p, "state2");
> pinctrl_select_state(p, s1);
> ...
> pinctrl_select_state(p, s2);
> ...
> pinctrl_put(p);
> 
> This allows devices to directly transition between states without
> disabling the pin controller programming and put()/get()ing the
> configuration data each time. This model will also better suit pinconf
> programming, which doesn't have a concept of "disable".
> 
> The special-case hogging feature of pin controllers is re-written to use
> the regular APIs instead of special-case code. Hence, the pinmux-hogs
> debugfs file is removed; see the top-level pinctrl-handles files for
> equivalent data.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v3: Rebased. No logical changes.
> v2: Make use of PINCTRL_STATE_DEFAULT, split out some documentation
> cleanup into an earlier patch. Various minor fixes. Fixes due to
> rebasing on updated earlier patches. Remove usecount field from struct
> pinctrl; allow only one concurrent pinctrl_get() per device.
> ---
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

I already acked it in v2, since no changes, ack it again. :-)

Regards
Dong Aisheng

