Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab1ACTxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 14:53:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60344
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932231Ab1ACTxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 14:53:05 -0500
Date: Mon, 03 Jan 2011 11:53:36 -0800 (PST)
Message-Id: <20110103.115336.70200097.davem@davemloft.net>
To: sedat.dilek@googlemail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sedat.dilek@gmail.com
Subject: Re: [PATCH] depca: Fix section mismatch derived from
 depca_isa_driver variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <1294021987-30385-1-git-send-email-sedat.dilek@gmail.com>
References: <1294021987-30385-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sedat Dilek <sedat.dilek@googlemail.com>
Date: Mon,  3 Jan 2011 03:33:07 +0100

>>From my build.log:
> 
> WARNING: drivers/net/depca.o(.data+0x0): Section mismatch in reference from the variable depca_isa_driver to the function .init.text:depca_isa_probe()
> The variable depca_isa_driver references
> the function __init depca_isa_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> This patch fixes the warning.
> 
> Tested with linux-next (next-20101231)
> 
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>

Again, mark depca_isa_probe() as __devinit to fix this bug.
