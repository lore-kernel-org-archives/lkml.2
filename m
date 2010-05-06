Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab0EFLLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 07:11:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55012 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751165Ab0EFLL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 07:11:29 -0400
Date: Thu, 6 May 2010 12:17:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: "nios2-dev@sopc.et.ntust.edu.tw" <nios2-dev@sopc.et.ntust.edu.tw>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Nios2-dev] [PATCH 1/2] serial: Add driver for the Altera JTAG
 UART
Message-ID: <20100506121700.0e4625de@lxorguk.ukuu.org.uk>
In-Reply-To: <1273143571.3477.29.camel@gentoo-ija64.mev.local>
References: <cover.1273048151.git.tklauser@distanz.ch>
	<e83e74abd82079284d5c8f62b78f2417ebc9ee27.1273048151.git.tklauser@distanz.ch>
	<1273143571.3477.29.camel@gentoo-ija64.mev.local>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I was originally responsible for adding the spin locks to these console
> putc functions, but I'm not sure what the policy is regarding that, as
> the 8250 driver doesn't use them for console output for example.

For the console it depends if you need them for internal consistency as I
understand the codebase. For the core stuff it currently protects
port->port.tty against a hangup which would drop the tty under you.

