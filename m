Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab2K1Jha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 04:37:30 -0500
Received: from mx3.cyfra.ua ([62.80.160.182]:40042 "EHLO mx3.cyfra.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab2K1Jh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 04:37:28 -0500
From: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Organization: Factor-SPE
To: "Hans J. Koch" <hjk@hansjkoch.de>
Subject: Re: [PATCH] drivers/uio/uio_pdrv_genirq.c: Fix memory leak & confusing labels
Date: Wed, 28 Nov 2012 11:37:23 +0200
User-Agent: KMail/1.9.10
Cc: Cong Ding <dinggnu@gmail.com>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <201211271929.32315.vitas@nppfactor.kiev.ua> <CAP9qxA-ZmhZLVujmdM0YLqXony-s8oZggKZxTU6oYmtcuO5erQ@mail.gmail.com> <20121128003750.GD2605@local>
In-Reply-To: <20121128003750.GD2605@local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201211281137.23623.vitas@nppfactor.kiev.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 November 2012 02:37:50 Hans J. Koch wrote:
>
> In other words, the case of uioinfo AND pdev->dev.of_node both being NULL
> is not handled properly and will have ugly results.
>

Moreover, the case of (uioinfo != NULL) && (pdev->dev.of_node != NULL) leads 
to equally ugly results too (freeing uoinfo when it is statically allocated).

I think, we should sort out these problems, but in another patch. It is 
totally unrelated to the problem solved by the original patch (memory leak 
caused by not freeing priv in case platform_get_irq() fails).
