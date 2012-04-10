Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378Ab2DJDis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 23:38:48 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:48161
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753391Ab2DJDir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 23:38:47 -0400
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 10 Apr 2012 11:49:28 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/1] pinctrl: add some error checking for user
 interfaces
Message-ID: <20120410034927.GA674@shlinux2.ap.freescale.net>
References: <1333967409-8168-1-git-send-email-b29396@freescale.com>
 <4F82FA2A.3090604@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F82FA2A.3090604@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 11:03:06PM +0800, Stephen Warren wrote:
> On 04/09/2012 04:30 AM, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > This patch can avoid kernel oops in case the mux or config
> > function is not supported by driver.
> > 
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > ---
> >  drivers/pinctrl/pinconf.c |    4 ++++
> >  drivers/pinctrl/pinmux.c  |   15 +++++++++++++--
> >  2 files changed, 17 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
> > index eb3a14f..384dcc1 100644
> > --- a/drivers/pinctrl/pinconf.c
> > +++ b/drivers/pinctrl/pinconf.c
> > @@ -448,8 +448,12 @@ static void pinconf_dump_pin(struct pinctrl_dev *pctldev,
> >  static int pinconf_pins_show(struct seq_file *s, void *what)
> >  {
> >  	struct pinctrl_dev *pctldev = s->private;
> > +	const struct pinconf_ops *ops = pctldev->desc->confops;
> >  	unsigned i, pin;
> >  
> > +	if (!ops || !ops->pin_config_get)
> > +		return 0;
> 
> I don't think this is necessary; it looks like this function (and those
> it calls) always checks ops where they're used.
> 
Yes, it's true.
But it will still dump all pins configs although there's no config value
which is almost the same as another debug entry 'pins'.
It looks it does not make too much sense to dump this info if no config support.
The existing pinconf_group_show did like this way(no output).
So i changed pinconf_pins_show in the same behavior as pinconf_group_show.

Do you think it's reasonable?

Regards
Dong Aisheng

