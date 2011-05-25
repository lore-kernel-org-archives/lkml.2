Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab1EYOnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:43:51 -0400
Received: from server514d.exghost.com ([72.32.253.69]:2045 "EHLO
	server514.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756087Ab1EYOnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:43:50 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 May 2011 10:43:50 EDT
X-Note-AR-ScanTimeLocal: 5/25/2011 9:33:14 AM
X-Policy: GLOBAL - virtualcomputer.com
X-Policy: GLOBAL - virtualcomputer.com
X-Policy: GLOBAL - virtualcomputer.com
X-Policy: GLOBAL - virtualcomputer.com
X-Primary: tom.goetz@virtualcomputer.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @virtualcomputer.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNITED STATES->PRIVATE->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 72.32.253.141
X-Note-Reverse-DNS: fe02.exg4.exghost.com
X-Note-WHTLIST: tom.goetz@virtualcomputer.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G195 G196 G197 G198 G202 G203 G214 G302 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
Subject: Re: [PATCH] xen: use the trigger info we already have to choose the irq handler
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Tom Goetz <tom.goetz@virtualcomputer.com>
In-Reply-To: <20110525142510.GA32231@dumpdata.com>
Date: Wed, 25 May 2011 10:33:47 -0400
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Content-Transfer-Encoding: 8BIT
Message-Id: <81AA5CC3-B436-468B-9581-9A5EDD80A9B8@virtualcomputer.com>
References: <alpine.DEB.2.00.1105251232020.12963@kaball-desktop> <20110525142510.GA32231@dumpdata.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
X-Mailer: Apple Mail (2.1084)
X-OriginalArrivalTime: 25 May 2011 14:33:48.0603 (UTC) FILETIME=[C292B0B0:01CC1AE8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 25, 2011, at 10:25 AM, Konrad Rzeszutek Wilk wrote:

> On Wed, May 25, 2011 at 12:33:23PM +0100, Stefano Stabellini wrote:
>> Do not use pirq_needs_eoi to decide which irq handler to use because Xen
>> always returns true if the guest does not support pirq_eoi_map.
>> Use the trigger information we already have from MP-tables and ACPI.
>> 
>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> Reported-by: Thomas Goetz <tcgoetz@gmail.com>
>> Tested-by: Thomas Goetz <tcgoetz@gmail.com>
> 
> Tom,
> 
> Do you prefer those email addresses or tom.goetz@virtualcomputer.com ?

It doesn't matter to me. I'm signed up to Xen devel with the gmail address because I signed up before we had a domain for the company and never bothered to change it.


> ..
>> -	if (pirq_needs_eoi(irq))
>> +	if (shareable)
> 
> Ok, so for dom0, the sharable flag is determined by the ACPI parsing.. good.
> And for MSI/MSI-X we use xen_bind_pirq_msi_to_irq which sets it to use handle_edge_irq.
> 
> The only hazard which you asked me on IRC is for PV guests with Xen PCI front.
> In those cases, we have no idea whether the "GSI" IRQ is edge or level and we
> just assume that anything under 16 is edge. Which is 99% right, except if you
> are to pass in the ACPI IRQ to the guest, or some other weird creature. The MSI/MSI-X
> part of the PCI front are OK too - they use the xen_bind_pirq_msi_to_irq call.
> 
> So, putting on the todo list an extension to the PCI PV protocol to pass information
> about the GSI's - whether they are edge or level.
> 
> Patch is on the 2.6.40-rc1 train.




