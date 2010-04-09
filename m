Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab0DIIbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 04:31:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59505 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab0DIIbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 04:31:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] Revert "memory-hotplug: add 0x prefix to HEX block_size_bytes"
Cc: kosaki.motohiro@jp.fujitsu.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <20100409014244.GB5644@localhost>
References: <20100408212918.GA2716@osiris.boeblingen.de.ibm.com> <20100409014244.GB5644@localhost>
Message-Id: <20100409172442.80EF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Apr 2010 17:31:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Heiko,
> 
> On Fri, Apr 09, 2010 at 05:29:18AM +0800, Heiko Carstens wrote:
> > On Thu, Apr 08, 2010 at 11:41:24PM +0800, Américo Wang wrote:
> > > On Thu, Apr 08, 2010 at 05:10:06PM +0200, Heiko Carstens wrote:
> > > >From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > >
> > > >Revert ba168fc37dea145deeb8fa9e7e71c748d2e00d74 "memory-hotplug: add 0x prefix
> > > >to HEX block_size_bytes" since it changes the user space visible sysfs interface
> > > >/sys/devices/system/memory/block_size_bytes.
> > > >The change breaks existing user space applications which rely on the fact that
> > > >the output does not contain the "0x" prefix.
> > > 
> > > Odd.
> > > 
> > > Which application relies on this? Isn't the application which should
> > > be fixed?? It should use something like strtoul() which doesn't
> > > rely on '0x' prefix.
> > 
> > Ok, consider it the other way round: your application is doing strtoul()
> > with a base of 0 (since you rely on the 0x prefix) and for no good reason
> > it doesn't work on older kernels.
> > I really can't see a reason for adding additional pitfalls by _changing_
> > a long existing user space interface.
> 
> Ack to revert it. Sorry for killing your time! 

I agree to revert, too. I guess nobody see my NAK for original mail (;_;)



