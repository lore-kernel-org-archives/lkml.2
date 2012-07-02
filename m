Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab2GBPQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:16:51 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:35143 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab2GBPQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:16:50 -0400
Date: Mon, 2 Jul 2012 17:16:20 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8 v3] i2c: i801: check INTR after every transaction
Message-ID: <20120702171620.5628d044@endymion.delvare>
In-Reply-To: <20120702120814.47d71bc5@endymion.delvare>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
	<1340805255-8041-4-git-send-email-djkurtz@chromium.org>
	<20120627180724.762f854a@endymion.delvare>
	<20120701232051.308c03d1@endymion.delvare>
	<CAGS+omDV_ynBL-PN0qmLmDRiHGbQFf+TwqC2-+KJY8zy9FDhrA@mail.gmail.com>
	<20120702120814.47d71bc5@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2012 12:08:14 +0200, Jean Delvare wrote:
> On Mon, 2 Jul 2012 09:19:24 +0800, Daniel Kurtz wrote:
> > My understanding is that the INTR wait is really waiting for the
> > entire transaction to complete (ie., including i2c STOP condition),
> > not just the byte transfer phase.
> 
> This is my understanding as well, but I'm fairly certain that this is
> the case of the BUSY flag as well. I think BUSY gets cleared at the
> same time INTR (or any of the error status bits) gets set. Which is why
> I think checking BUSY is redundant. As a matter of fact, we ignore BUSY
> completely in i801_block_transaction_byte_by_byte(), so I see no reason
> why we couldn't do the same in i2c_transaction().

To be complete, I made some testing and error bits can be set before
BUSY is cleared. I spotted several transitions 0x41 -> 0x45 -> 0x44
when accessing non-existent devices. On success, I never witnessed INTR
and BUSY being set at the same time, transition is always 0x41 -> 0x42.

-- 
Jean Delvare
