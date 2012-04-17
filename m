Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab2DQDbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 23:31:46 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:55855
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753330Ab2DQDbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 23:31:45 -0400
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 17 Apr 2012 11:42:11 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/1] pinctrl: handle dummy state in core
Message-ID: <20120417034210.GD17173@shlinux2.ap.freescale.net>
References: <1334586289-13078-1-git-send-email-b29396@freescale.com>
 <4F8C42D6.2000607@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F8C42D6.2000607@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 12:03:34AM +0800, Stephen Warren wrote:
> On 04/16/2012 08:24 AM, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > Remove dummy state user interface and handle it totally in core.
> > This can make it more easy to use by platforms which has neither pinctrl
> > driver support nor dt support.
> > 
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> 
> I think this is the wrong direction.
> 
> I specifically want people to think about which drivers require what
> pinctrl states to be defined, and what their content should be, and
> hence explicitly define dummy states when it's appropriate. This patch
> prevents that.
> 
It's correct if all platforms have switched to pinctrl subsystem.

I think the main issue is for one platform neither supports dt nor using pinctrl
subsystem, do you think it still makes too much sense to force that platform
to define a _PINCTRL_ dummy state in their machine code?

But the driver is commonly shared between these different platforms(using pinctrl
or not).

That's why i proposed to handle dummy state in core in this patch rather than require
user to do it.

You must can assume there're so many platforms still have not switched to use pinctrl
subsystem. If we require user to do it, we need change many code.

Regards
Dong Aisheng

