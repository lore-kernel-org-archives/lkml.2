Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab2HDTnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 15:43:19 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:10973 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2HDTnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 15:43:17 -0400
Date: Sat, 4 Aug 2012 21:43:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/i2c/i2c-smbus.c: convert kzalloc to
 devm_kzalloc
Message-ID: <20120804214305.2c18b13a@endymion.delvare>
In-Reply-To: <1344100248-16238-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1344100248-16238-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Sat,  4 Aug 2012 19:10:48 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Converting kzalloc to devm_kzalloc simplifies the code and ensures that the
> result, alert, is freed after the irq allocated by the subsequent
> devm_request_irq.  This in turn ensures that when an interrupt can be
> triggered, the alert structure is still available.

Good point. I honestly have no idea why this driver's resources are
half managed, it doesn't make much sense...

Patch applied, with a comment clarified, thanks.

-- 
Jean Delvare
