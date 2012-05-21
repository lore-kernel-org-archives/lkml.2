Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab2EUNwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 09:52:47 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45689 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755863Ab2EUNwq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 09:52:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120521130451.GK2313@8bytes.org>
References: <20120518231238.31187.44571.stgit@bhelgaas.mtv.corp.google.com>
 <20120518231832.31187.10630.stgit@bhelgaas.mtv.corp.google.com> <20120521130451.GK2313@8bytes.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 21 May 2012 07:52:24 -0600
Message-ID: <CAErSpo582Ok9arr+3krKTQdue4i3wQOixVkBbheDX6a3v8xMHw@mail.gmail.com>
Subject: Re: [PATCH 1/2] resources: set type of new resource returned by __request_region()
To: Joerg Roedel <joro@8bytes.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 7:04 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Fri, May 18, 2012 at 05:18:32PM -0600, Bjorn Helgaas wrote:
>> Previously we returned a new struct resource with only IORESOURCE_BUSY
>> set (and possibly IORESOURCE_MUXED or IORESOURCE_EXCLUSIVE), but no
>> MEM/IO/etc. bits set.  The new resource should inherit the type of
>> its parent.
>
> Should it? What about IORESOURCE_WINDOW for example? Any particular
> reason for this change to the interface of the __request_region()
> function?

Yes, I should have explained the connection :)  The next patch prints
the resource returned from request_mem_region().  Without this
__request_region() patch, that resource has no type, so %pR can't
print it correctly.

Good question about IORESOURCE_WINDOW.  Maybe it should inherit only
the IORESOURCE_TYPE_BITS part (IO/MEM/IRQ/DMA/BUS).  But it seemed
like it should also inherit PREFETCH, READONLY, CACHEABLE, etc.  Maybe
we should inherit everything but clear IORESOURCE_WINDOW?  I'm open to
suggestions here.

Bjorn
