Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab2GIPIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 11:08:23 -0400
Received: from smtp.citrix.com ([66.165.176.89]:45164 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab2GIPIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 11:08:22 -0400
X-IronPort-AV: E=Sophos;i="4.77,552,1336363200"; 
   d="scan'208";a="30849553"
Message-ID: <4FFAF3E3.7070306@citrix.com>
Date: Mon, 9 Jul 2012 16:08:19 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <tim@xen.org>,
        <linux-kernel@vger.kernel.org>, <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] [PATCH WIP 2/6] xen/arm: Introduce xen_guest_init
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com>	<1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>	<1340381685-22529-2-git-send-email-stefano.stabellini@eu.citrix.com> <20120709144505.GD12102@phenom.dumpdata.com>
In-Reply-To: <20120709144505.GD12102@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/12 15:45, Konrad Rzeszutek Wilk wrote:
> On Fri, Jun 22, 2012 at 05:14:41PM +0100, Stefano Stabellini wrote:
>> We used to rely on a core_initcall to initialize Xen on ARM, however
>> core_initcalls are actually called after early consoles are initialized.
>> That means that hvc_xen.c is going to be initialized before Xen.
>>
>> Given the lack of a better alternative, just call a new Xen
>> initialization function (xen_guest_init) from xen_cons_init.
>>
>> xen_guest_init has to be arch independant, so write both an ARM and an
>> x86 implementation. The x86 implementation is currently empty because we
>> can be sure that xen_hvm_guest_init is called early enough.
>>
>> Probably we can get rid of this as soon as we have better DT support.
> 
> What is DT?

Device Tree.  It's a binary describing the hardware and some system
configuration that is passed to the kernel by the boot loader or (in
this case) the hypervisor.  Vaguely analogous to ACPI except it's not
crazy ;).

We really should get the device tree bindings sorted out before
accepting any kernel side patches.  I think we can do this even if Xen's
device tree support is incomplete.

David
