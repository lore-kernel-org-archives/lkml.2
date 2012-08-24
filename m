Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2HXCvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 22:51:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59374 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab2HXCvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 22:51:31 -0400
Message-ID: <5036EC1E.5030804@zytor.com>
Date: Thu, 23 Aug 2012 19:51:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v7 0/12] x86: Arbitrary CPU hot(un)plug support
References: <1345769771-27019-1-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1345769771-27019-1-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fenghua,

This patchset breaks compiling with Xen enabled on 64 bits:

/home/hpa/kernel/tip.x86-hotplug/arch/x86/xen/smp.c: In function 
‘cpu_bringup’:
/home/hpa/kernel/tip.x86-hotplug/arch/x86/xen/smp.c:75:2: error: too few 
arguments to function ‘smp_store_cpu_info’
In file included from 
/home/hpa/kernel/tip.x86-hotplug/include/linux/smp.h:38:0,
                  from 
/home/hpa/kernel/tip.x86-hotplug/include/linux/sched.h:70,
                  from 
/home/hpa/kernel/tip.x86-hotplug/arch/x86/xen/smp.c:15:
/home/hpa/kernel/tip.x86-hotplug/arch/x86/include/asm/smp.h:169:6: note: 
declared here
/home/hpa/kernel/tip.x86-hotplug/arch/x86/xen/smp.c: In function 
‘xen_smp_prepare_cpus’:
/home/hpa/kernel/tip.x86-hotplug/arch/x86/xen/smp.c:257:2: error: too 
few arguments to function ‘smp_store_cpu_info’
In file included from 
/home/hpa/kernel/tip.x86-hotplug/include/linux/smp.h:38:0,
                  from 
/home/hpa/kernel/tip.x86-hotplug/include/linux/sched.h:70,
                  from 
/home/hpa/kernel/tip.x86-hotplug/arch/x86/xen/smp.c:15:
/home/hpa/kernel/tip.x86-hotplug/arch/x86/include/asm/smp.h:169:6: note: 
declared here
make[4]: *** [arch/x86/xen/smp.o] Error 1
make[3]: *** [arch/x86/xen] Error 2
make[2]: *** [arch/x86] Error 2
make[1]: *** [sub-make] Error 2
make[1]: Leaving directory `/home/hpa/kernel/tip.x86-hotplug'

Could you fix that?

	-hpa

