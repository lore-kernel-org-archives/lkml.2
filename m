Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab1C3Q66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:58:58 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:53719 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab1C3Q65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:58:57 -0400
X-IronPort-AV: E=Sophos;i="4.63,269,1299456000"; 
   d="scan'208";a="5056583"
Date: Wed, 30 Mar 2011 17:59:16 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: another pagetable initialization crash on xen
In-Reply-To: <alpine.DEB.2.00.1103301714250.16492@kaball-desktop>
Message-ID: <alpine.DEB.2.00.1103301748380.16492@kaball-desktop>
References: <alpine.DEB.2.00.1103281729190.5516@kaball-desktop> <alpine.DEB.2.00.1103281929390.5516@kaball-desktop> <alpine.DEB.2.00.1103291620560.16492@kaball-desktop> <4D9221DA.90900@kernel.org> <alpine.DEB.2.00.1103301714250.16492@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Stefano Stabellini wrote:
> I have another unrelated question: init_memory_mapping is called on the
> range 0 - max_low_pfn, but that range usually includes a reserved region
> below the first MB. On one machine of mine the IOAPIC mmio region falls
> in that memory range therefore we are mapping the IOAPIC mmio region in
> init_memory_mapping without going through the fixmap as we should.
> This is causing problems on Xen, but I guess it could theoretically
> cause problems on other platforms as well. Should we avoid reserved
> memory regions below the first MB from the initial memory mappings?

Sorry I mixed up frame numbers with physical addresses, so the IOAPIC
mmio region is actually at 0xfec00000 where it should be but it gets
mapped during the initial memory mapping (range 0 - 0x100000000).
Is that supposed to happen? Shouldn't it go through the fixmap?
