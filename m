Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab2ALPsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 10:48:14 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:35532 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab2ALPsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 10:48:13 -0500
Date: Thu, 12 Jan 2012 10:46:13 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sander Eikelenboom <linux@eikelenboom.it>, kay.sievers@vrfy.org,
        linux-kernel@vger.kernel.org
Cc: xen-devel <xen-devel@lists.xensource.com>
Subject: Re: linux 3.3-pre-rc1: Starting domU fails with Error: Failed to
 query current memory allocation of dom0.
Message-ID: <20120112154613.GA10148@phenom.dumpdata.com>
References: <498097597.20120112133832@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498097597.20120112133832@eikelenboom.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F0F00B8.00A8,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 01:38:32PM +0100, Sander Eikelenboom wrote:
> Hi Konrad,
> 
> Today i tried linuses tree of today (last commit is 4c4d285ad5665bfbd983b95fde8d7a477d24a361).
> 
> It boots dom0 fine, but it fails to start any domU with: "Error: Failed to query current memory allocation of dom0."
> With my previous 3.1.5 kernel everything is fine, nothing else changed in config in between.

Hey Kay,

Your patch that converts the xen-balloon to use the regular device bus driver
(070680218379e15c1901f4bf21b98e3cbf12b527) has some not-so-happy consequences.

The toolstack (xen-tools) use:

/sys/devices/system/xen_memory/xen_memory0

But with the change, it is now:

/sys/devices/xen_memory0/target_kb

Which means that the tools can't find it now.

I did not see anything in feature-removal-schedule.txt so I don't know
exactly when the full sys_device structure is going away.

Is there any work-arounds that can be inserted in the kernel so that
the old directory still exists at least for 3.3 such that there will be
enough time for the tool-stack to be updated?
