Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab1HITCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:02:37 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:61655 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab1HITCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:02:36 -0400
Date: Tue, 9 Aug 2011 15:02:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH 0/3] [v4] kexec and kdump for Xen PVonHVM
 guests
Message-ID: <20110809190215.GA19789@dumpdata.com>
References: <20110804162053.723541930@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110804162053.723541930@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E418444.0077:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 06:20:53PM +0200, Olaf Hering wrote:
> 
> 
> The following series implements kexec and kdump in a Xen PVonHVM guest.
> 
> It is (should be) available via git:
> 
>  git://github.com/olafhering/linux.git xen-kexec-3.0
> 
> The kexec or kdump kernel has to take care of already allocated virqs,
> PV devices in Closed or Connected state, and of registered watches in
> the old kernel. With the three patches these conditions are checked
> during boot of the new kernel rather than in the reboot/crash path.
> 
> A fixed kexec-tools-2.0.2 package is required:
> http://lists.infradead.org/pipermail/kexec/2011-May/005026.html
> http://lists.infradead.org/pipermail/kexec/2011-August/005339.html
> 
> Another fix is for xenstored, it has to accept the XS_INTRODUCE from a guest:
> http://lists.xensource.com/archives/html/xen-devel/2011-08/msg00007.html
> 
> One open issue is the balloon driver. It removes pages from the guest
> and gives them back to the hypervisor. The kexec kernel is not aware of
> the fact that some pages are unavailable, and hangs or crashes.
> The workaround for the time being is:
> 
> if test -f /sys/devices/system/xen_memory/xen_memory0/target -a \
>         -f /sys/devices/system/xen_memory/xen_memory0/target_kb
> then
>     cat /sys/devices/system/xen_memory/xen_memory0/target > \
>         /sys/devices/system/xen_memory/xen_memory0/target_kb
> fi
> kexec -e
> 
> This has to be resolved with another series of changes.

You are just plowing through these bugs and fixing. Thanks for doing it!

I think one more revision and they will be ready?
