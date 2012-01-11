Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab2AKX1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 18:27:13 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:63906 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab2AKX1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 18:27:08 -0500
Date: Thu, 12 Jan 2012 00:26:36 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: alan@linux.intel.com
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jgarzik@pobox.com,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 6/6] ahci: support the STA2X11 I/O Hub
Message-ID: <20120111232636.GA19503@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20120111225748.3e80a52d@bob.linux.org.uk>
References: <20120111225748.3e80a52d@bob.linux.org.uk>
  <3bffc0889fba822f58b5f8607fa5247c6f50649c.1325852059.git.rubini@gnudd.com>
  <78cef636f264afa64de043be2018b5d66290240e.1325852059.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I miscopied linux-ide to inux-ide in the original submission. I'm
now fixing the typo. This is the original patch and I quote Alan
without removing anything: https://lkml.org/lkml/2012/1/6/124 ]

>> The AHCI controller found in the STA2X11 chip uses BAR number 0
>> instead of 5. Also, the chip's fixup code sets a special DMA mask
>> for all of its PCI functions, and the mask must be preserved here.
> 
> The more I look at this aspect of it the more convinced I grow that you
> should handle this in the DMA ops.
> 
> dma_supported will call ops->dma_supported which can in turn make its
> own decisions and avoid driver hackery.

The problem is that there's dma_capable() somewhere. Currently I have
very bad feeling about dma_capable and I'll try to turn that to
dma_supported as soon as possible (the code I got changed the
behaviour of dma_capable, which is a global change impacting on
others).

thanks
/alessandro
