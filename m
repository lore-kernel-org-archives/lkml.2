Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0FCTo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:44:56 -0400
Received: from claw.goop.org ([74.207.240.146]:57112 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab0FCToz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:44:55 -0400
Message-ID: <4C080636.9060508@goop.org>
Date: Thu, 03 Jun 2010 12:44:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH 0/12] PV on HVM Xen
References: <alpine.DEB.2.00.1006011435570.3401@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1006011435570.3401@kaball-desktop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2010 06:07 AM, Stefano Stabellini wrote:
> Hi all,
> the last update on the PV on HVM Xen series contains the following
> changes:
>
> - some variables and functions have been renamed following Jeremy's
> suggestions, in particular:
> s/init_shared_info/xen_hvm_init_shared_info
> s/xen_platform_pci/xen_platform_pci_enabled
> s/UNPLUG_/XEN_UNPLUG_
>
> - the two platform_pci.h header files have been merged and the useless
> intro has been removed;
>
> - the xen platform pci product number and driver versions have been made
> static;
>
> - the description on the VIRQ_TIMER patch has been improved;
>
> - a new patch to fix hpet behaviour has been introduced: hpet_disable is
> called unconditionally on machine shutdown, and doesn't check whether
> hpet has been actually enabled, causing trouble if it hasn't;
>
> - the vector callback patch has been improved: we don't use the ipi
> vector anymore but we allocate our own so that we can avoid useless and
> expensive vlapic acks.
>   

I think they're worse than that; I think they could end up potentially
acking a pending interrupt which hasn't been delivered yet.

>
> Meanwhile the vector callback patch for xen has been checked into
> xen-unstable, so you don't need a separate patch for xen anymore to take
> full advantage of this patch series.
>
> A git tree is available here:
>
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git
>
> branch name 2.6.34-pvhvm-v3.
>   

Thanks,

    J
