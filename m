Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab2ITNa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:30:29 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:60506 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab2ITNa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:30:28 -0400
X-IronPort-AV: E=Sophos;i="4.80,453,1344211200"; 
   d="scan'208";a="14657372"
Message-ID: <1348147826.26501.47.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH] arm: introduce a DTS for Xen unprivileged virtual
 machines
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Date: Thu, 20 Sep 2012 14:30:26 +0100
In-Reply-To: <505B0C00.5010003@arm.com>
References: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1348135563.11116.94.camel@hornet>
	 <alpine.DEB.2.02.1209201235450.29232@kaball.uk.xensource.com>
	 <1348142133.11116.109.camel@hornet>
	 <alpine.DEB.2.02.1209201308490.29232@kaball.uk.xensource.com>
	 <505B0C00.5010003@arm.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 13:28 +0100, Marc Zyngier wrote:
> I think the important thing here is that the memory map is RS1. As this
> is a (very limited) subset of a vexpress A15, it seems to make some sense.

Looking at arch/arm/boot/dts/vexpress-v2m-rs1.dtsi I don't think we
provide anything which is on rs1 though.

The Xen VM environment has only a gic (via a combination of the gic
virtualisation mode for CPU regs and emulation for the distributor), the
arch timers and xenbus (which is the s/w bus which Xen uses to discover
its paravirtualised peripherals).

Currently we provide a very simple output only emulation of UART0,
simply to get the debug output from the decompresser, but we want that
to go away not get baked in.

Ian.

