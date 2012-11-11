Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2KKWtv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 17:49:51 -0500
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:44993 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab2KKWtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 17:49:49 -0500
Message-Id: <201211112247.qABMlWiQ021630@thirdoffive.cmf.nrl.navy.mil>
From: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>
To: Krzysztof Mazur <krzysiek@podlesie.net>
cc: David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3 8/7] pppoatm: fix missing wakeup in pppoatm_send()
In-reply-to: <20121111110437.GA25894@shrek.podlesie.net>
Date: Sun, 11 Nov 2012 17:47:32 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20121111110437.GA25894@shrek.podlesie.net>,Krzysztof Mazur writes:
>Any race with testing vcc flags is probably not really important
>because:
>	- vcc_release_async() does not take any lock so this check
>	  will be always racy so we are probably allowed to send
>	  new frames until vcc is really closed,

this locking/synchronization is handled in the atm device drivers.
the send and close routines are responsbile for synchronization (yes, i
believe that leads to duplicated code but that is the way it currently is)
