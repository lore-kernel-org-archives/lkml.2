Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab0EFQ7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:59:37 -0400
Received: from p01c11o144.mxlogic.net ([208.65.144.67]:59774 "EHLO
	p01c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab0EFQ7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:59:35 -0400
X-MXL-Hash: 4be2f57716baf4c2-3d0a7685ac220a4f401fc56f980a84a4b5232dc9
X-MXL-Hash: 4be2f56403ab568f-8d66c5c4ec21024a202a11122ec30aebc089aad5
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <greg@kroah.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>, Greg KH <gregkh@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Date: Thu, 6 May 2010 11:59:03 -0500
Subject: RE: Staging: dt3155: Cleanup memory mapped i/o access
Thread-Topic: Staging: dt3155: Cleanup memory mapped i/o access
Thread-Index: AcrrzVnGlPVK+abARvq4qHcYDK7nTAAAbAfQAFuFByA=
Message-ID: <0D753D10438DA54287A00B0270842697636ECB4D7B@AUSP01VMBX24.collaborationhost.net>
References: <20100503211751.GB21402@kroah.com>
	<0D753D10438DA54287A00B0270842697636EADE1D2@AUSP01VMBX24.collaborationhost.net>
	<0D753D10438DA54287A00B0270842697636EADE26A@AUSP01VMBX24.collaborationhost.net>
	<20100503234123.GC13519@suse.de>
	<1272931198.30040.218.camel@Joe-Laptop.home>
	<20100504025430.GA26421@suse.de>	<1273000031.4143.56.camel@Joe-Laptop.home>
	<0D753D10438DA54287A00B0270842697636EB83CE8@AUSP01VMBX24.collaborationhost.net>
	<20100504201207.GA7096@kroah.com>
	<0D753D10438DA54287A00B0270842697636EB83E2A@AUSP01VMBX24.collaborationhost.net>
	<20100504210229.GA21128@kroah.com>
 <0D753D10438DA54287A00B0270842697636EB83EC9@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <0D753D10438DA54287A00B0270842697636EB83EC9@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2694214079; CM=0.500; S=0.269(2010050402)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.97]
X-AnalysisOut: [v=1.0 c=1 a=n2LqRRw_DHMA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=qhvANl0glaz90f+3g7Keqg==:17 a=i00gxMtYAAAA:8 a=83S]
X-AnalysisOut: [pfD-y7EInmUnQUOIA:9 a=j_6EKV-xf3ZYaalE1YGraMhEVs0A:4 a=Cju]
X-AnalysisOut: [IK1q_8ugA:10 a=x1WnkoZAwusA:10 a=0kPLrQdw3YYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 04, 2010 2:23 PM, H Hartley Sweeten wrote:
>
> The macros ReadMReg and WriteMReg are really just private versions of
> the kernel's readl and writel functions.  Use the kernel's functions
> instead.  And since ioremap returns a (void __iomem *) not a (u8 *),
> change all the uses of dt3155_lbase to reflect this.
>
> While here, make dt3155_lbase static since it is only used in the
> dt3155_drv.c file.  Also, remove the global variable dt3155_bbase
> since it is not used anywhere in the code.
>
> Where is makes sense, create a local 'mmio' variable instead of using
> dt3155_lbase[minor] to make the code more readable.
>
> This change also affects the {Read|Write}I2C functions so they are
> also modified as needed.
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Scott Smedley <ss@aao.gov.au>
>

Greg,

Did this patch fair any better when trying to merge it?

If there is still an issue I will wait until Linus' tree, linux-next,
and your staging-next branch appear to be more in sync.

Regards,
Hartley