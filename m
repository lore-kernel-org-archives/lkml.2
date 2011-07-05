Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab1GEOt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:49:28 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:65451 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab1GEOt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:49:26 -0400
USER-AGENT: Mutt/1.5.21 (2010-09-15)
MIME-Version: 1.0
Message-ID: <20110705144846.GA13548@dumpdata.com>
Date: Tue, 5 Jul 2011 07:48:46 -0700 (PDT)
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
        jeremy.fitzhardinge@citrix.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [TOME] Re: [PATCH] Modpost section mismatch fix
References: <20110703232508.GB4440@Xye>
 <1309769388.634.51.camel@zakaz.uk.xensource.com> <20110704221646.GB4490@Xye>
 <20110705141323.GG2972@dumpdata.com> <20110705142731.GA4463@Xye>
In-Reply-To: <20110705142731.GA4463@Xye>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090205.4E132466.009B:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>xen_register_gsi and hence, xen_register_pirq are called from
> >>init (with xen_setup_acpi_sci) and non-init (with
> >>acpi_register_gsi_xen); since xen_set_acpi_sci calls it with gsi ==
> >>acpi_sci_override_gsi and is marked __init, the best way would be to
> >>call xen_register_gsi and xen_register_pirq with a boolean argument like
> >>sci_override to obviate the need to use acpi_sci_override_gsi in
> >>register_pirq. I will send the patch with this change if it looks good.
> >
> >Hold on, let me rebase #stable/pci.cleanups and see if the issue
> >here disappears.
> Thanks, will wait until the rebase and test after that.

Hm, it actually looks like it wont do the trick. Why don't you send
a patch against 3.0-rc6 with the outlined mechanism mentioned above.
