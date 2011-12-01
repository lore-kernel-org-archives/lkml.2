Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1LCOmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 09:42:22 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:50767 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab1LCOmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 09:42:10 -0500
Date: Thu, 1 Dec 2011 09:35:48 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>, deepthi@linux.vnet.ibm.com
Subject: Re: 3.2-rc2+: Reported regressions from 3.0 and 3.1
Message-ID: <20111201143548.GA28114@phenom.dumpdata.com>
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
 <201111212249.31196.rjw@sisk.pl>
 <20111122135412.GA29905@phenom.dumpdata.com>
 <20111129180414.GA11459@phenom.dumpdata.com>
 <20111129183428.GE8200@aftab>
 <20111130175936.GA15168@phenom.dumpdata.com>
 <20111201113919.GC31552@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201113919.GC31552@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4EDA351F.004F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >From what I can see, you get the following callchain:
> 
> start_kernel
> |-> setup_arch
>     |-> x86_init.oem.arch_setup = xen_arch_setup
>     ....
>     |-> check_bugs
>         |-> identify_boot_cpu
> 	    |-> identify_cpu
> 	        |-> select_idle_routine
> 
> 
> so xen_arch_setup will set pm_idle and select_idle_routine will honour
> it. I'm being told this is run either in the dom0 or the paravirt guest
> and if so, I don't see any issue with this for baremetal. So you can
> have my ACK provided this is tested on baremetal too.

Tested on baremetal and there were no abnormalities. Thanks!
