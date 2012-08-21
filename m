Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2HULc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:32:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:26790 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab2HULc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:32:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,802,1336374000"; 
   d="scan'208";a="183459019"
Date: Tue, 21 Aug 2012 12:50:05 +0100
From: Alan Cox <alan@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>
Subject: Re: [RFC/PATCH 02/13] serial: omap: always return IRQ_HANDLED
Message-ID: <20120821125005.235926e0@bob.linux.org.uk>
In-Reply-To: <1345540555-24359-3-git-send-email-balbi@ti.com>
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
	<1345540555-24359-3-git-send-email-balbi@ti.com>
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

On Tue, 21 Aug 2012 12:15:44 +0300
Felipe Balbi <balbi@ti.com> wrote:

> Even if we enter our IRQ handler just to notice
> that the our device didn't generate the IRQ,
> that still means "handling" and IRQ, so let's
> return IRQ_HANDLED.

That looks wrong - you'll defeat the stuck IRQ protection. If we didn't
cause the IRQ then we are IRQ_NONE ?

