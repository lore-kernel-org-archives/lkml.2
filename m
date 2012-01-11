Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071Ab2AKWom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 17:44:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:10908 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab2AKWok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 17:44:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="95415699"
Date: Wed, 11 Jan 2012 22:57:48 +0000
From: Alan Cox <alan@linux.intel.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jgarzik@pobox.com,
        inux-ide@vger.kernel.org
Subject: Re: [PATCH 6/6] ahci: support the STA2X11 I/O Hub
Message-ID: <20120111225748.3e80a52d@bob.linux.org.uk>
In-Reply-To: <78cef636f264afa64de043be2018b5d66290240e.1325852059.git.rubini@gnudd.com>
References: <3bffc0889fba822f58b5f8607fa5247c6f50649c.1325852059.git.rubini@gnudd.com>
	<78cef636f264afa64de043be2018b5d66290240e.1325852059.git.rubini@gnudd.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jan 2012 13:33:39 +0100
Alessandro Rubini <rubini@gnudd.com> wrote:

> The AHCI controller found in the STA2X11 chip uses BAR number 0
> instead of 5. Also, the chip's fixup code sets a special DMA mask
> for all of its PCI functions, and the mask must be preserved here.

The more I look at this aspect of it the more convinced I grow that you
should handle this in the DMA ops.

dma_supported will call ops->dma_supported which can in turn make its
own decisions and avoid driver hackery.

Alan
