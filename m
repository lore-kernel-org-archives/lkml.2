Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0LGKXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 05:23:45 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:7980 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab0LGKXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 05:23:44 -0500
X-IronPort-AV: E=Sophos;i="4.59,310,1288569600"; 
   d="scan'208";a="3219542"
Date: Tue, 7 Dec 2010 10:23:44 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Sheng Yang <sheng@linux.intel.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] xen: HVM X2APIC support
In-Reply-To: <1291708317-25103-2-git-send-email-sheng@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1012071020210.2390@kaball-desktop>
References: <1291708317-25103-1-git-send-email-sheng@linux.intel.com> <1291708317-25103-2-git-send-email-sheng@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, Sheng Yang wrote:
> +bool xen_hvm_need_lapic(void)
> +{
> +	if (xen_pv_domain())
> +		return false;
> +	if (xen_hvm_domain() &&
> +	   (xen_feature(XENFEAT_hvm_pirqs) || xen_have_vector_callback))
> +		return false;
> +	return (xen_cpuid_base() != 0);
> +}
> +EXPORT_SYMBOL_GPL(xen_hvm_need_lapic);
> +

Why do you want to disable x2apic
if (xen_have_vector_callback && !xen_feature(XENFEAT_hvm_pirqs))?
In this case some emulated devices are still used, like the serial, and
need interrupt delivery using an apic. Same is true for all the
pci devices assigned to the VM.
The only case in which the apic is basically left unused is
(xen_feature(XENFEAT_hvm_pirqs) && xen_have_vector_callback).
 
