Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118Ab0DHV3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:29:01 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:54015 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759076Ab0DHV3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:29:00 -0400
Date: Thu, 8 Apr 2010 23:29:18 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <andi@firstfloor.org>,
       Greg KH <greg@kroah.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       stable@kernel.org
Subject: Re: [PATCH] Revert "memory-hotplug: add 0x prefix to HEX
 block_size_bytes"
Message-ID: <20100408212918.GA2716@osiris.boeblingen.de.ibm.com>
References: <20100408151006.GB2446@osiris.boeblingen.de.ibm.com>
 <20100408153745.GA4213@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100408153745.GA4213@hack>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 11:41:24PM +0800, Américo Wang wrote:
> On Thu, Apr 08, 2010 at 05:10:06PM +0200, Heiko Carstens wrote:
> >From: Heiko Carstens <heiko.carstens@de.ibm.com>
> >
> >Revert ba168fc37dea145deeb8fa9e7e71c748d2e00d74 "memory-hotplug: add 0x prefix
> >to HEX block_size_bytes" since it changes the user space visible sysfs interface
> >/sys/devices/system/memory/block_size_bytes.
> >The change breaks existing user space applications which rely on the fact that
> >the output does not contain the "0x" prefix.
> 
> Odd.
> 
> Which application relies on this? Isn't the application which should
> be fixed?? It should use something like strtoul() which doesn't
> rely on '0x' prefix.

Ok, consider it the other way round: your application is doing strtoul()
with a base of 0 (since you rely on the 0x prefix) and for no good reason
it doesn't work on older kernels.
I really can't see a reason for adding additional pitfalls by _changing_
a long existing user space interface.
