Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab1AJHEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 02:04:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:45467 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1AJHEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 02:04:21 -0500
Message-ID: <4D2AAEDD.5060604@kernel.org>
Date: Sun, 09 Jan 2011 23:01:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <greg@kroah.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 1/3] pci, usb: Seperate usb handoff func to another file
References: <4D2A1152.1040903@kernel.org>  <4D2A139A.6010108@kernel.org> <1294607382.17779.282.camel@pasglop>
In-Reply-To: <1294607382.17779.282.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2011 01:09 PM, Benjamin Herrenschmidt wrote:
> acceptable ?
> 
> I think if you want to make the handoff happen -that- early, you have
> basically two options. One is to move it all to arch code, and the other
> one is to create early-boot "fake" struct pci_dev & bus that have the
> config callbacks implemented pointing to the early stuff. You can do
> that entirely within your arch code, and avoids most of the grossness
> above in the generic places.

good idea, will make one get_early_pci_dev() for x86 as dummy device.

> 
> It would avoid that turd too:
> 
>> +#include "usb_handoff.c"

may still need that to avoid some MMIO bar finding and remapping etc.

Thanks

Yinghai
