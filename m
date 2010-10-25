Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab0JYQWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:22:20 -0400
Received: from smtp.citrix.com ([66.165.176.89]:50159 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab0JYQWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:22:19 -0400
X-IronPort-AV: E=Sophos;i="4.58,236,1286164800"; 
   d="scan'208";a="10796142"
Subject: [PATCH 00/05] xen: events: cleanups after irq core improvements
 (Was: Re: [Xen-devel] Re: [tip:irq/core] x86: xen: Sanitise sparse_irq
 handling)
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>
References: <tip-77dff1c755c3218691e95e7e38ee14323b35dbdb@git.kernel.org>
	 <4CB8EE8A.5020900@goop.org> <4CB8EF30.7060504@goop.org>
	 <6a6702dc-7dbb-47a3-a0cf-18c8a65252fe@email.android.com>
In-Reply-To: <6a6702dc-7dbb-47a3-a0cf-18c8a65252fe@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Mon, 25 Oct 2010 17:22:16 +0100
Message-ID: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-16 at 01:17 +0100, Jeremy Fitzhardinge wrote:
> Of course the really interesting question is whether this sparse irq
> rework allows us to hang our extra per-irq information of the irq_data
> structure now, rather than having to maintain all these auxiliary
> arrays?

On Sat, 2010-10-16 at 03:01 +0100, H. Peter Anvin wrote: 
> It should.

I'm about to followup with an initial stab at some cleanups which are
made possible by these core changes, including hanging the per-irq info
off the handler_data.

These patches are on top of recent Linus master tree plus Konrad's
swiotlb-xen tree and Stefano's PVHVM tree since the latter in particular
touches the same area.

Ian. 

