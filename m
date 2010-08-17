Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab0HQIyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:54:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:54923 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab0HQIx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:53:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,381,1278313200"; 
   d="scan'208";a="828875708"
Date: Tue, 17 Aug 2010 09:16:22 +0100
From: Alan Cox <alan@linux.intel.com>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>
Subject: Re: One question about 8250 UART driver
Message-ID: <20100817091622.5aa3dcf2@linux.intel.com>
In-Reply-To: <20100817013734.GA28407@ywang-moblin2.bj.intel.com>
References: <20100817013734.GA28407@ywang-moblin2.bj.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 09:37:34 +0800
Yong Wang <yong.y.wang@linux.intel.com> wrote:

> Hi all,
> 
> We have a PCI based UART controller that is compatible with the
> existing 8250 serial driver in most aspects. However, one exception
> is that our UART controller can take advantage of the onboard DMA
> contoller to achieve higher throughput. Could you please share your
> insights about what is the proper way to add such DMA support into
> existing 8250 driver?

I'd say the same as I said to the other folks who asked this - create a
new driver. All the DMA based 8250 devices have differing DMA engines
and it'll become unmanagable in the existing driver.

Once we can see which bits of the existing code are useful for the DMA
8250-style devices we can then create an 8250-lib.c which contains the
bits that are useful to 8250 and to non standard 8250-like devices.

Alan
