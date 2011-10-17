Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab1JQJc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 05:32:26 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:44893 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab1JQJcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:32:25 -0400
X-IronPort-AV: E=Sophos;i="4.69,358,1315180800"; 
   d="scan'208";a="8417950"
Subject: longterm backport request: xen/timer: Missing IRQF_NO_SUSPEND in
 timer code broke suspend
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Greg KH <greg@kroah.com>, "stable@kernel.org" <stable@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 17 Oct 2011 10:32:24 +0100
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318843944.16132.3.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending since I suspect stable@ was down the first time round. Also I
should have CC'd Thomas & LKML, I think)

Hi Greg,

Please can you queue this commit for 3.6.32.y

        commit f611f2da99420abc973c32cdbddbf5c365d0a20c
        Author: Ian Campbell <Ian.Campbell@citrix.com>
        Date:   Tue Feb 8 14:03:31 2011 +0000
        
            xen/timer: Missing IRQF_NO_SUSPEND in timer code broke suspend.
            
            The patches missed an indirect use of IRQF_NO_SUSPEND pulled in via
            IRQF_TIMER. The following patch fixes the issue.
            
            With this fixlet PV guest migration works just fine. I also booted the
            entire series as a dom0 kernel and it appeared fine.
            
            Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
            Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

It is needed in any tree which contains 676dc3cf5bc3 "xen: Use
IRQF_FORCE_RESUME" but not this change (everything was fixed upstream in
2.6.39-rc1).

It's a bit hard to tell in the absence of kernel.org but I have an old
(but post February) checkout of the 2.6.35 longterm and it does not appear
to have the original problematic patch so the fix isn't needed there.
IOW AFAICT right now 2.6.32 seems to be the only relevant tree.

Thanks,
Ian.



