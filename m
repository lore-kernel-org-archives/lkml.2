Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2ILJ0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:26:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:45212 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab2ILJ03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:26:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,408,1344236400"; 
   d="scan'208";a="220964789"
Date: Wed, 12 Sep 2012 10:44:20 +0100
From: Alan Cox <alan@linux.intel.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Colin Cross <ccross@android.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?ISO-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [RFC] tty/serial/kgdboc: Add and wire up clear_irqs callback
Message-ID: <20120912104420.06a88957@bob.linux.org.uk>
In-Reply-To: <20120912040657.GA3880@lizard>
References: <20120911093042.GA12471@lizard>
	<1347356106-25368-6-git-send-email-anton.vorontsov@linaro.org>
	<20120911151540.362001c6@pyramind.ukuu.org.uk>
	<20120912033209.GA32156@lizard>
	<CAMbhsRTmZyxFE-vAa-UvNE8KJ2f0cfXP7mncXKcpUiNF6C9PUQ@mail.gmail.com>
	<20120912040657.GA3880@lizard>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Of course, if Alan is OK with this, I'm more than OK too. :-)

It may well be better.

> (But the polling routines would need to clear all interrupts, not
> just rx/tx. For example, if the controller indicated some error, and
> nobody clears it, then we'll start reentering infinitely.)

For a lot of devices and platforms you'd probably mask them instead ?

> 
> > If you use a clear_irqs callback, you can drop characters if
> > one arrives between the last character buffer read and calling
> > clear_irqs.
> 
> Only if we call clear_irqs() after reading the characters, but we do
> it before. So if new characters are available, we will reenter NMI,
> which is OK.

Recursively or not... again you get platform specific magic in places
we don't want.

In the driver poll method for most uarts is going to be at least buried
in what is usually arch specific uarts.

