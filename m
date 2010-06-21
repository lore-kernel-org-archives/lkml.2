Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab0FUQOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:14:00 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:58400 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab0FUQN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:13:59 -0400
X-IronPort-AV: E=Sophos;i="4.53,453,1272844800"; 
   d="scan'208";a="514377"
Date: Mon, 21 Jun 2010 17:14:01 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH 0/12] PV on HVM Xen
In-Reply-To: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
Message-ID: <alpine.DEB.2.00.1006211713170.18470@kaball-desktop>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As usual I mistyped the topic, the series is made up of 13 patches now
:)

On Mon, 21 Jun 2010, Stefano Stabellini wrote:
> Hi all,
> this is another update on the PV on HVM Xen series; a list of changes
> compared to the previous version follows:
> 
> - the bug caused by modprobing xen frontend modules when xenbus is not
> initialized has been fixed: now xenbus is always initialized during
> postcore_initcall, before device drivers are initialized, so that we
> can be sure that loading xen pv frontends will always happen afterwards,
> no matter how the xen platform pci driver is built.
> In order to do that xenbus_probe has been moved out of the xenbus
> initialization and called it later on at device_initcall.
> 
> - a new HVMOP_pagetable_dying hypercall has been added to notify Xen
> that a pagetable is going to be destroyed: this improves performances
> significantly when running on shadow pagetables.
> A patch is currently need on the Xen side for this to work.
> 
> Jeremy's comments have been addressed:
> 
> - xen_guest_init has been renamed xen_hvm_guest_init;
> 
> - init_hvm_time has been moved to arch/x86/xen/time.c;
> 
> Konrad's comments have been addressed:
> 
> - gnttab_max_nr_grant_frames has been renamed gnttab_max_grant_frames;
> 
> - few inaccurate comments have been rewritten;
> 
> - the preprocessor checks in platform-pci-unplug.c have been moved to
> platform_pci.h;
> 
> - few other code style improvements, like using dev_err instead of
> printk and strncmp instead of strcmp.
> 
> 
> 
> A git tree is available here:
> 
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git
> 
> branch name 2.6.34-pvhvm-v4.
> 
> Cheers,
> 
> Stefano
> 
