Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab1BCWgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 17:36:36 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:40306 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab1BCWgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 17:36:35 -0500
Date: Fri, 4 Feb 2011 00:36:32 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: linux-parisc@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.38-rc3 regression on parisc: segfaults
In-Reply-To: <1296598360.18277.11.camel@mulgrave.site>
Message-ID: <alpine.SOC.1.00.1102040018390.16704@math.ut.ee>
References: <alpine.SOC.1.00.1102012342200.25944@math.ut.ee> <1296598360.18277.11.camel@mulgrave.site>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I have been testing devel kernels on SMP L1000 successfully until 
> > 2.6.38-rc2-00324-g70d1f36 included. The testing means booting the new 
> > kernel and running aptitude to update to current debian unstable.
> > 
> > Now I tried 2.6.38-rc3 and got a crash from aptitude on 2 out of 2 
> > tries. Maybe aptitude was broken inbetween but it looks like a kernel 
> > bug. Retried 2.6.38-rc2-00324-g70d1f36 and that seemed to work fine so 
> > it's more likely a kernel problem.
> > 
> > What additional information can I provide?
> 
> Probably a bisection, if you could.  There have been no parisc patches
> between -rc2 and -rc3, so it's coming from outside the architecture.

The result is strange :(

6b28405395f7ec492ea69f541cc774adcb9e00ca is the first bad commit
commit 6b28405395f7ec492ea69f541cc774adcb9e00ca
Author: Axel Köllhofer <AxelKoellhofer@web.de>
Date:   Sat Jan 22 14:33:50 2011 -0600

    staging: r8712u: Add new device IDs

    This patch adds several new device ids to the r8712u staging driver.
    The new ids were retrieved from latest vendor driver (v2.6.6.0.20101111)
    downloadable from www.realtek.com.tw

    Signed-off-by: Axel Koellhofer <AxelKoellhofer@web.de>
    Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
    Cc: Stable <stable@kernel.org> [2.6.37]
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 185c3d2c1e98cc99009bfb772ed0779410784110 f5aa903931116f28f803003f594fec3b2a29a6f6 M      drivers

Seems absolutely unrelated - I do not have staging enabled so so no 
CONFIG_R8712U either.

The "bad" bisects were clearly bad and failed quicky during aptitude 
list update but the good ones might have needed more stress... or it is 
some alignment-like problem. Will try again starting from these bad 
bisects to narrow it down, and stress seemingly good ones better.

-- 
Meelis Roos (mroos@linux.ee)
