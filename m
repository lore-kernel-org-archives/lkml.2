Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab2CKVFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 17:05:34 -0400
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:54148 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2CKVF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 17:05:27 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Mar 2012 17:05:27 EDT
Message-Id: <201203112058.q2BKwBCS024617@cmf.nrl.navy.mil>
From: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>
To: Julia Lawall <Julia.Lawall@lip6.fr>
cc: kernel-janitors@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] drivers/atm/eni.c: ensure arguments to request_irq and free_irq are compatible
In-reply-to: <1331494587-12196-6-git-send-email-Julia.Lawall@lip6.fr>
Date: Sun, 11 Mar 2012 16:58:11 -0400
X-NRLCMF-Spam-Score: () hits=-1.01
X-NRLCMF-Virus-Scanned: No virus found
X-NRLCMF-Languages: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i am pretty sure that request_irq() shouldnt be changed but rather
free_irq() changed.  the last argument of request_irq() is passed to the
interrupt routine (ent_int in this case).  if you change that you need
to update the interrupt routine.  fixing free_irq would be easier.

In message <1331494587-12196-6-git-send-email-Julia.Lawall@lip6.fr>,Julia Lawall writes:
>Convert call to request_irq so that the last argument is the same as the
>second argument of the subsequent call to free_irq.  Without this
>property, free_irq does nothing.
>
>I have chosen to keep the call to free_irq as is, because its second
>argument is more like its first argument.
