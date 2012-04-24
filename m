Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2DXTEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:04:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33342 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036Ab2DXTEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:04:30 -0400
Message-ID: <4F96F93B.2020603@wwwdotorg.org>
Date: Tue, 24 Apr 2012 13:04:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de
Subject: Re: [PATCH v2 2/2] pinctrl: remove the old pinctrl dt dummy state
 interfaces
References: <1335260023-15859-1-git-send-email-b29396@freescale.com> <1335260023-15859-2-git-send-email-b29396@freescale.com>
In-Reply-To: <1335260023-15859-2-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 03:33 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> We already have pinctrl_provide_dummies, so remove the old
> one to avoid diversity.

Nak, if I may be so bold.

> Hi Stephen,
> I removed the old dt pinctrl dummy sate interface.
> The purpose is to get a unified way to handle pinctrl dummy state.

Well, there are two completely different scenarios being covered here,
and I don't think it makes sense to unify them:

1) Platform under development without complete pinctrl support yet
(covered by patch 1 in this series).

2) Platform with complete pinctrl support, but using some common HW
modules whose drivers need to use pinctrl on some platforms, but not on
all, so that dummy states are required. This patch removes the ability
to correctly represent this situation.

> One disadvantage is that we may not meet the requirement
> that for platform which only want to use dummy state for some specific
> devices while not affect others. For this case, it may reply on users
> to refer to the pinctrl debug message to see which devices are using
> dummy state while which are not.
> However, if keep it we may have two type of user interface to handle
> dummy state which i'm not sure is a good thing. And as regulator also
> does not provide per device dummies, so i removed it first.

Well, first I'd say that if regulator didn't have this feature, it'd
probably just be a missing feature in regulator, and not a good
justification for removing the feature from pinctrl.

But that said, regulator does in fact have this feature - it's called
the fixed regulator.

> What's your suggestion on it?
> I reform this clean up into a separate patch, if you do not like it,
> we can drop it later.

I'd love to drop it, please.
