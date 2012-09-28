Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab2I1NCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:02:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:1187 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab2I1NB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:01:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,502,1344236400"; 
   d="scan'208";a="198352089"
Date: Fri, 28 Sep 2012 14:03:28 +0100
From: Alan Cox <alan@linux.intel.com>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: <gregkh@linuxfoundation.org>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH] tty/8250_early: Prevent rounding error in uartclk to
 baud ratio
Message-ID: <20120928140328.4ff68806@bob.linux.org.uk>
In-Reply-To: <1348834748-31565-1-git-send-email-abrodkin@synopsys.com>
References: <1348834748-31565-1-git-send-email-abrodkin@synopsys.com>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.11; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012 16:19:08 +0400
Alexey Brodkin <Alexey.Brodkin@synopsys.com> wrote:

> Modify divisor to select the nearest baud rate divider rather than the
> lowest. It minimizes baud rate errors especially on low UART clock
> frequencies.
> 
> For example, if uartclk is 33000000 and baud is 115200 the ratio is
> about 17.9 The current code selects 17 (5% error) but should select 18
> (0.5% error).
> 
> On the same lines as following:
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.9-rc3/2.6.9-rc3-mm2/broken-out/serial-pick-nearest-baud-rate-divider.patch
> 
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>

Seems sensible to me.

Acked-by: Alan Cox <alan@linux.intel.com>
