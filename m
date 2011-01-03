Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1ACS55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 13:57:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37586
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146Ab1ACS54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 13:57:56 -0500
Date: Mon, 03 Jan 2011 10:58:27 -0800 (PST)
Message-Id: <20110103.105827.112602895.davem@davemloft.net>
To: alex.buell@munted.org.uk
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Using s3virge card in Sun Blade 2000
From: David Miller <davem@davemloft.net>
In-Reply-To: <1294072336.17576.7.camel@lithium>
References: <1294072336.17576.7.camel@lithium>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Buell <alex.buell@munted.org.uk>
Date: Mon, 03 Jan 2011 16:32:16 +0000

> I'm aware the s3fb driver has big endian issues, I can help fix those
> issues so I can get the card working. Or in other words, I'd welcome
> advice on how to proceed with this. 

It's not endian issues, this driver has other problems.

It uses the VGA register accessors with a NULL regbase, which is not
going to work on sparc64.

It needs to access the VGA register space relative to the I/O space
of the PCI controller domain it is behind.

Probably if you replace the NULL values passes to vga_r*() and
vga_w*() with the I/O space resource base of the chip (should be
resource "1") it might work.
