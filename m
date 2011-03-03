Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab1CCIhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:37:11 -0500
Received: from smtp.tele.fi ([192.89.123.25]:57523 "EHLO
	vulpes-int.media.sonera.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750818Ab1CCIhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:37:10 -0500
X-Greylist: delayed 2315 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Mar 2011 03:37:09 EST
X-Originating-Ip: [194.89.68.22]
Date: Thu, 3 Mar 2011 09:58:28 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: topperxin <topperxin@126.com>
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH v2 0/6] Xen PV on HVM fixes and improvements
Message-ID: <20110303075828.GE5345@reaktio.net>
References: <alpine.DEB.2.00.1102251651570.19277@kaball-desktop> <50e6b629.254d.12e798c9072.Coremail.topperxin@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50e6b629.254d.12e798c9072.Coremail.topperxin@126.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 10:29:38AM +0800, topperxin wrote:
>    Hi stefano,
>       It's very great of your work.I think it't useful
>    to me, I have checked it out, and I will study it.
>      What I care mostly is the pv-on-hvm drivers, now
>    my main work is port pvonhvm drivers to various guest
>    OS, no matter what OS version, such as ubuntu 10.10,
>    debian 505 etc. But I found this work is difficult &
>    boring to me, I can't find a general method which can
>    easily port the pvonhvm drivers to all kinds guest os.
>    Do you have any good ideas?
>       I found there are not platform-pci source in your
>    project, as we know, in the old pvonhvm drivers version,
>    platform-pci module is important, it was used to establish
>    the communication mechanism, such as xenbus, evtchn,etc,
>    could you please tell me how can you get rid of it? and how
>    can you substitute platform-pci, with which?
>        Thanks a lot.

Hey,

Not sure if you've seen this wiki page..it has some links to
various versions of pv-on-hvm drivers for linux:

http://wiki.xen.org/xenwiki/XenLinuxPVonHVMdrivers

-- Pasi

> 
>  At 2011-02-26 01:11:33**"Stefano Stabellini" <Stefano.Stabellini@eu.citrix.com> wrote:
> 
>  >Hi all,
>  >this patch series is a collection of fixes and improvements for Linux
>  >running as Xen PV on HVM guest.
>  >Changes to the previous version:
>  >
>  >- patch 5 and 6 have been squashed together;
>  >
>  >- xen_hvm_spinlock_init has been merged into xen_hvm_smp_prepare_cpus.
>  >
>  >
>  >The list of patches with diffstat follows:
>  >
>  >Stefano Stabellini (6):
>  >      xen: no need to delay xen_setup_shutdown_event for hvm guests anymore
>  >      xen: do not use xen_info on HVM, set pv_info name to "Xen HVM"
>  >      xen-blkfront: handle Xen major numbers other than XENVBD
>  >      xen: make the ballon driver work for hvm domains
>  >      xen: PV on HVM: support PV spinlocks and IPIs
>  >      xen: fix compile issue if XEN is enabled but XEN_PVHVM is disabled
>  >
>  > arch/x86/xen/enlighten.c         |    6 ++-
>  > arch/x86/xen/smp.c               |   38 ++++++++++++++++++
>  > arch/x86/xen/suspend.c           |    2 +
>  > arch/x86/xen/xen-ops.h           |    2 +
>  > drivers/block/xen-blkfront.c     |   79 +++++++++++++++++++++++++++++++++++--
>  > drivers/xen/balloon.c            |   14 ++++--
>  > drivers/xen/manage.c             |   17 ++------
>  > drivers/xen/platform-pci.c       |    3 -
>  > include/xen/interface/io/blkif.h |   21 ++++++++++
>  > 9 files changed, 154 insertions(+), 28 deletions(-)
>  >
>  >A branch with these patches on 2.6.38-rc6 is available here:
>  >
>  >git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.38-rc6-pvhvm
>  >
>  >Cheers,
>  >
>  >Stefano
>  >
>  >_______________________________________________
>  >Xen-devel mailing list
>  >Xen-devel@lists.xensource.com
>  >http://lists.xensource.com/xen-devel

> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel

