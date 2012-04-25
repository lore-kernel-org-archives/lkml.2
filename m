Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139Ab2DYLzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:55:15 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:28651 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757383Ab2DYLzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:55:13 -0400
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 25 Apr 2012 20:05:10 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Subject: Re: [PATCH v2 2/2] pinctrl: remove the old pinctrl dt dummy state
 interfaces
Message-ID: <20120425120509.GC17631@shlinux2.ap.freescale.net>
References: <1335260023-15859-1-git-send-email-b29396@freescale.com>
 <1335260023-15859-2-git-send-email-b29396@freescale.com>
 <4F96F93B.2020603@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F96F93B.2020603@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 03:04:27AM +0800, Stephen Warren wrote:
> On 04/24/2012 03:33 AM, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > We already have pinctrl_provide_dummies, so remove the old
> > one to avoid diversity.
> 
> Nak, if I may be so bold.
> 
No, it's fine to me.
Since i'm not sure this patch is really needed, so i sent it out to
request for your comment.

> > Hi Stephen,
> > I removed the old dt pinctrl dummy sate interface.
> > The purpose is to get a unified way to handle pinctrl dummy state.
> 
> Well, there are two completely different scenarios being covered here,
> and I don't think it makes sense to unify them:
> 
> 1) Platform under development without complete pinctrl support yet
> (covered by patch 1 in this series).
> 
> 2) Platform with complete pinctrl support, but using some common HW
> modules whose drivers need to use pinctrl on some platforms, but not on
> all, so that dummy states are required. This patch removes the ability
> to correctly represent this situation.
> 
Looks reasonable to me.

> > One disadvantage is that we may not meet the requirement
> > that for platform which only want to use dummy state for some specific
> > devices while not affect others. For this case, it may reply on users
> > to refer to the pinctrl debug message to see which devices are using
> > dummy state while which are not.
> > However, if keep it we may have two type of user interface to handle
> > dummy state which i'm not sure is a good thing. And as regulator also
> > does not provide per device dummies, so i removed it first.
> 
> Well, first I'd say that if regulator didn't have this feature, it'd
> probably just be a missing feature in regulator, and not a good
> justification for removing the feature from pinctrl.
> 
> But that said, regulator does in fact have this feature - it's called
> the fixed regulator.
> 
Yes, i see.

> > What's your suggestion on it?
> > I reform this clean up into a separate patch, if you do not like it,
> > we can drop it later.
> 
> I'd love to drop it, please.
Okay, we can drop it.

Regards
Dong Aisheng

