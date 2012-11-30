Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab2K3BjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:39:18 -0500
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:38180 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2K3BjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:39:14 -0500
Message-Id: <201211300138.qAU1c8sE003388@thirdoffive.cmf.nrl.navy.mil>
From: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>
To: David Woodhouse <dwmw2@infradead.org>
cc: Krzysztof Mazur <krzysiek@podlesie.net>,
        David Laight <David.Laight@ACULAB.COM>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nathan@traverse.com.au
Subject: Re: [PATCH v2 3/3] pppoatm: protect against freeing of vcc
In-reply-to: <1354227428.21562.230.camel@shinybook.infradead.org>
Date: Thu, 29 Nov 2012 20:38:08 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1354227428.21562.230.camel@shinybook.infradead.org>,David Woodhouse writes:
>At this point, I think we're better off as we are (with Krzysztof's
>patch 1/7 dropped, and leaving vcc->dev->ops->close() being called
>before vcc->push(NULL). We've fairly much solved the issues with that
>arrangement, by checking ATM_VF_READY in the protocols' ->push()
>functions.

it isnt clear to me that fixes the race entirely either.
vcc_destroy_socket() and any of the push()/sends()'s are not serialized.
while you may clear the ATM_VF_READY flag, you might not clear it soon
enough for any particular push() that is already running.  so it still
seems like you are racing close() against push() at this point.  the
window is greatly reduced, but it still exists.
