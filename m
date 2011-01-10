Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1AJJkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 04:40:05 -0500
Received: from gate.crashing.org ([63.228.1.57]:44515 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab1AJJkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 04:40:03 -0500
Subject: Re: [PATCH 1/3] pci, usb: Seperate usb handoff func to another file
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <greg@kroah.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
In-Reply-To: <4D2AAEDD.5060604@kernel.org>
References: <4D2A1152.1040903@kernel.org>  <4D2A139A.6010108@kernel.org>
	 <1294607382.17779.282.camel@pasglop>  <4D2AAEDD.5060604@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 20:38:16 +1100
Message-ID: <1294652296.17779.299.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-09 at 23:01 -0800, Yinghai Lu wrote:
> On 01/09/2011 01:09 PM, Benjamin Herrenschmidt wrote:
> > acceptable ?
> > 
> > I think if you want to make the handoff happen -that- early, you have
> > basically two options. One is to move it all to arch code, and the other
> > one is to create early-boot "fake" struct pci_dev & bus that have the
> > config callbacks implemented pointing to the early stuff. You can do
> > that entirely within your arch code, and avoids most of the grossness
> > above in the generic places.
> 
> good idea, will make one get_early_pci_dev() for x86 as dummy device.
> 
> > 
> > It would avoid that turd too:
> > 
> >> +#include "usb_handoff.c"
> 
> may still need that to avoid some MMIO bar finding and remapping etc.

Might be better to test for system state... a bit ugly too but less than
#include'ing the C file.

Cheers,
Ben.


