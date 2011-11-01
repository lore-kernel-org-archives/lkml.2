Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab1KATof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:44:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:42518 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab1KAToe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:44:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="69909768"
Date: Tue, 1 Nov 2011 19:55:17 +0000
From: Alan Cox <alan@linux.intel.com>
To: Paul Schilling <paul.s.schilling@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Boojin Kim <boojin.kim@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 02/14] ARM : SAMSUNG : Add RS485 support.
Message-ID: <20111101195517.5334482c@bob.linux.org.uk>
In-Reply-To: <CAC=G6sxm9YJZsi_+Zq7YVYsQrw1SAFvnroPxGyH7JGRn7ko5nw@mail.gmail.com>
References: <1319255194-4799-1-git-send-email-paul.s.schilling@gmail.com>
	<20111101121851.7d393277@bob.linux.org.uk>
	<CAC=G6swE7WCqTFkJkOm_GXpVncjXrc+-jvaKHiwc9KTb6Re8hQ@mail.gmail.com>
	<CAC=G6szKRbyJXTXOCyDaF3rEfaiVCktTU6y0Fwohh6qf2VD-_A@mail.gmail.com>
	<CAC=G6sxm9YJZsi_+Zq7YVYsQrw1SAFvnroPxGyH7JGRn7ko5nw@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The opinion part...  I needed a timer to switch from transmit to
> receive after the FIFO was empty.  I started by using the low
> resolution timer using jiffies first.  I found that wasn't high enough
> resolution, so I switched to the Linux HRT.  Currently I have both
> versions that can be selected by conditional compile.  Should I
> just remove the low resolution timer completely or leave it in.

I would just remove the low res one. They should degrade to low res
timer equivalence anyway.

> Second, I have a chunk of code that if it could be made to work
> could off load the receiving to DMA up to the last couple of bytes
> then switch back to interrupts for the token byte.  Should I leave
> that code in a #if 0 statement or should I just delete it.

Is it something that you are likely to debug or someone is going to
debug shortly ?
