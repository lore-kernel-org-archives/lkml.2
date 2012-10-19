Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151Ab2JSXCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 19:02:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:12627 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933108Ab2JSXCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 19:02:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,617,1344236400"; 
   d="scan'208";a="208308036"
Subject: Re: x2apic boot failure on recent sandy bridge system
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: rrl125@gmail.com
Cc: fa.linux.kernel@googlegroups.com, "Berck E. Nash" <flyboy@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 19 Oct 2012 16:03:58 -0700
In-Reply-To: <b0b75b2b-961b-487a-ab03-2362c65d6972@googlegroups.com>
References: <fa.1zfuXwqYK6u81uBoo3IdpawcpWw@ifi.uio.no>
	 <fa.p3cpkKIGUNv0/iot3o7KT9bb98M@ifi.uio.no>
	 <fa.iPHW7usT23k+cCA19L3eXEDu91Q@ifi.uio.no>
	 <fa.7eOK+XcsKUWU4ZXhBj2K6znxrvc@ifi.uio.no>
	 <fa.VGxfKOh1Z07X1TXm5PxMIlV4xu8@ifi.uio.no>
	 <fa.eH+BpYDdp4xIWE4V+wJu6hFrVxM@ifi.uio.no>
	 <b0b75b2b-961b-487a-ab03-2362c65d6972@googlegroups.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1350687838.6017.10.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 13:42 -0700, rrl125@gmail.com wrote:
> Any update? The messages just seem to have stopped months ago. A
> fallback would be nice, I have been booting the kernel with noa2xpic
> for since kernel 3.2, and currently I am working with 3.6.2.
> 
> If needed I can try to attempt modifying the patch to include
> fallback, but I am probably not the best person to do it.
> 

Are you referring to this commit that made into the mainline tree
already?

commit fb209bd891645bb87b9618b724f0b4928e0df3de
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Wed Dec 21 17:45:17 2011 -0800

    x86, x2apic: Fallback to xapic when BIOS doesn't setup interrupt-remapping
    
    On some of the recent Intel SNB platforms, by default bios is pre-enabling
    x2apic mode in the cpu with out setting up interrupt-remapping.
    This case was resulting in the kernel to panic as the cpu is already in
    x2apic mode but the OS was not able to enable interrupt-remapping (which
    is a pre-req for using x2apic capability).
    
    On these platforms all the apic-ids are < 255 and the kernel can fallback to
    xapic mode if the bios has not enabled interrupt-remapping (which is
    mostly the case if the bios has not exported interrupt-remapping tables to the
    OS).
    
    Reported-by: Berck E. Nash <flyboy@gmail.com>
    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Link: http://lkml.kernel.org/r/20111222014632.600418637@sbsiddha-desk.sc.intel.com
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>


