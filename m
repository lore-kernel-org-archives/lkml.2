Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab1JCQa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:30:28 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27865 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab1JCQaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:30:21 -0400
Date: Mon, 3 Oct 2011 12:30:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [Xen-devel] [PATCH 8/9] xen/enlighten: Fix compile warnings.
Message-ID: <20111003163001.GG17108@phenom.oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
 <1317325971-21603-9-git-send-email-konrad.wilk@oracle.com>
 <1317370252.26672.224.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1317370252.26672.224.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090204.4E89E319.0154,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 09:10:51AM +0100, Ian Campbell wrote:
> On Thu, 2011-09-29 at 20:52 +0100, Konrad Rzeszutek Wilk wrote:
> > linux/arch/x86/xen/enlighten.c: In function ‘xen_start_kernel’:
> > linux/arch/x86/xen/enlighten.c:226: warning: ‘cx’ may be used uninitialized in this function
> > linux/arch/x86/xen/enlighten.c:240: note: ‘cx’ was declared here
> 
> Before 61f4237d5b005767a76f4f3694e68e6f78f392d9 we used to initialise cx
> to zero before calling xen_cpuid.
> 
> 947ccf9c3c30307b774af3666ee74fcd9f47f646 didn't put it back for some
> reason.
> 
> Regardless I'm not sure how cx can be unused while {a,b,d}x apparently
> are not. All four are passed to xen_cpuid(&ax, &bx, &cx, &dx) and even
> if gcc were being clever and looking into xen_cpuid all four are in the
> output constraints of the real cpuid asm call.
> 
> Oh, I see, ax and cx are also in the input side of the asm and ax is
> initialised but cx is not and that is the use not the one later in
> xen_init_cpuid_mask.
> 
> I think that even if cpuid leaf ax=1 happens not to use the subleaf
> index in cx we'd be better to initialise cx=0 than use uninitialized_var

<nods> I somehow read the code as 'cx' being set in xen_cpuid, but your
analysis correct. Done!

