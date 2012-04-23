Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab2DWQRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:17:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:1876 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab2DWQRK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:17:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="134250431"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Borislav Petkov <bp@amd64.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "Luck, Tony" <tony.luck@intel.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jan Beulich <jbeulich@suse.com>
Subject: RE: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Thread-Topic: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Thread-Index: AQHNIRekE+T8UaKT7UOvaY1icgqRWJaoiIsA
Date: Mon, 23 Apr 2012 16:17:03 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335168E54@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
 <20120421041454.GA29704@phenom.dumpdata.com>
 <20120421104502.GB17005@aftab.osrc.amd.com>
 <20120423021827.GA13840@phenom.dumpdata.com>
 <20120423060921.GA29378@aftab.osrc.amd.com>
In-Reply-To: <20120423060921.GA29378@aftab.osrc.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 
>> This driver is not that much different from the APEI bridge to MCE
>> code - 
>> it just that instead of reading APEI blob data it reads it from an
>> hypercall. 
> 
> Let me ask you this: is APEI a virtualization solution of some sort?
> 
> No, it is the old windoze RAS crap but I guess Linux has to support it
> now too through BIOS. And x86 vendors will have to support it too.
> 
> So it is piece of the firmware we'd have to deal with too.
> 
> Now xen is a whole another deal - it is purely a piece of software.

But the role of xen (in fact, including other virtual solution like lguest/kvm) is virtual 'platform', equal to native h/w 'platform'.

> 
> Now I keep wondering, why don't you guys simply create your own mcelog
> ring buffer and interface on the userspace tool side instead of
> hooking into lowlevel kernel stuff? I mean, the code is there, you
> simply have to copy it into arch/xen/ or whatever you have there. Why
> do you have to hook into arch/x86/ instead of doing your own stuff?
> 
>>> So, my suggestion is to copy the pieces you need and create your
>>> own xen version of /dev/mcelog and add it to dom0 so that there's
>>> no hooking into baremetal code and whenever a dom0 kernel is
>>> running, you can reroute the mcelog userspace tool to read
>>> /dev/xen_mcelog or whatever and not hook into the x86 versions.

That would make distro camp confusing -- i.e. SLES10/11 unifiedly use /dev/mcelog for both native and xen mcelog, w/ almost same dom0 mcelog logic as this patch.

>>> 
>>> Because, if you'd hooked into it, just imagine one fine day, when we
>>> remove mcelog support, what screaming the xen people will be doing
>>> when mcelog doesn't work anymore.
>> 
>> You would have more screaming from the distro camp about removing
>> /dev/mcelog.
> 
> How do you know that? Don't you think that we probably would've talked
> to them already and made preparations for conversion first?

I guess Novell Suse doubt this.

Thanks,
Jinsong