Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0IVQy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:54:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58788 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab0IVQy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:54:28 -0400
Message-ID: <4C9A3487.6080005@zytor.com>
Date: Wed, 22 Sep 2010 09:53:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, yinghai@kernel.org,
        just.for.lkml@googlemail.com, tglx@linutronix.de, hpa@linux.intel.com,
        Feng Tang <feng.tang@intel.com>, Alan Cox <alan@linux.intel.com>,
        greg@kroah.com
Subject: Re: Early console confusion
References: <4C7B0578.8090807@kernel.org> <201009220912.45360.bjorn.helgaas@hp.com> <4C9A271F.30608@zytor.com> <201009221044.58735.bjorn.helgaas@hp.com>
In-Reply-To: <201009221044.58735.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 09:44 AM, Bjorn Helgaas wrote:
>
> If we don't like "uart8250,io,0x3f8" (which I agree is awfully clunky),
> we could easily add something like "console=com1" which encapsulated
> the well-defined PC concept.

console=ttyS0 ... already works fine.

> It would be similar to "earlyprintk=ttyS0",
> and if it could be made *enough* like it, maybe "earlyprintk=ttyS0"
> could be dropped.
>
> I also see the recent "earlyprintk=hsu" patch from  Feng Tang, and I
> wonder whether that could be recast in the "console=hsu" style.  Like
> "com1", "hsu" is apparently enough to specifically identify a device.
>
> I think it's nicer to extend "console=" in ways that allow early
> devices, because then users don't have to mess with both "console="
> and "earlyprintk=".  The 8250_early driver has a reasonable model
> of switching from the early device to the real one automatically,
> so maybe something like this is all we would need:

console= is supported multiple times, and enabling console= shouldn't 
necessarily enable earlyprintk...

But yes, it's ugly and we have bass-ackwards compatibility problem...

	-hpa
