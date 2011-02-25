Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab1BYTd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 14:33:58 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:16821 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932754Ab1BYTd5 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 25 Feb 2011 14:33:57 -0500
Date: Fri, 25 Feb 2011 14:32:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH v2 0/6] Xen PV on HVM fixes and improvements
Message-ID: <20110225193230.GA17090@dumpdata.com>
References: <alpine.DEB.2.00.1102251651570.19277@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102251651570.19277@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D68041D.001B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 05:11:33PM +0000, Stefano Stabellini wrote:
> Hi all,
> this patch series is a collection of fixes and improvements for Linux
> running as Xen PV on HVM guest.
> Changes to the previous version:

Looks good to me. I am surprised that it was that easy to get the balloon
code to work under HVM..

> 
> - patch 5 and 6 have been squashed together;
> 
> - xen_hvm_spinlock_init has been merged into xen_hvm_smp_prepare_cpus.
> 
> 
> The list of patches with diffstat follows:
> 
> Stefano Stabellini (6):
>       xen: no need to delay xen_setup_shutdown_event for hvm guests anymore
>       xen: do not use xen_info on HVM, set pv_info name to "Xen HVM"
>       xen-blkfront: handle Xen major numbers other than XENVBD
>       xen: make the ballon driver work for hvm domains
>       xen: PV on HVM: support PV spinlocks and IPIs
>       xen: fix compile issue if XEN is enabled but XEN_PVHVM is disabled
> 
>  arch/x86/xen/enlighten.c         |    6 ++-
>  arch/x86/xen/smp.c               |   38 ++++++++++++++++++
>  arch/x86/xen/suspend.c           |    2 +
>  arch/x86/xen/xen-ops.h           |    2 +
>  drivers/block/xen-blkfront.c     |   79 +++++++++++++++++++++++++++++++++++--
>  drivers/xen/balloon.c            |   14 ++++--
>  drivers/xen/manage.c             |   17 ++------
>  drivers/xen/platform-pci.c       |    3 -
>  include/xen/interface/io/blkif.h |   21 ++++++++++
>  9 files changed, 154 insertions(+), 28 deletions(-)
> 
> A branch with these patches on 2.6.38-rc6 is available here:
> 
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.38-rc6-pvhvm
> 
> Cheers,
> 
> Stefano
