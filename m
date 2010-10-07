Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab0JGVSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:18:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55003 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab0JGVSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:18:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6129"; a="56990945"
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
From: Daniel Walker <dwalker@codeaurora.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
In-Reply-To: <AANLkTi==_WDX03gYRa0=qCSgZ2eoO-Uzpg66WeEX57rS@mail.gmail.com>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
	 <AANLkTinxorq2XhJdGDNQuUghxzr1q6OW=S1VjupOu5nH@mail.gmail.com>
	 <1286480364.23836.17.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTi=8Et=Z6zrzbZa3L0MO=cBjjh7L=XU2=PDEbzWW@mail.gmail.com>
	 <1286481532.23836.27.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTi=j2n-X+-zkas8HdL1awo7Lcyxwofts6FjU8vj6@mail.gmail.com>
	 <1286482013.23836.29.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTinDvL9vPb6nmve3rO9dMtMAqh=d1oqBVTOHzYWH@mail.gmail.com>
	 <1286485186.23836.56.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTi==_WDX03gYRa0=qCSgZ2eoO-Uzpg66WeEX57rS@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 14:17:54 -0700
Message-ID: <1286486274.23836.62.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 17:05 -0400, Mike Frysinger wrote:
> On Thu, Oct 7, 2010 at 16:59, Daniel Walker wrote:
> > On Thu, 2010-10-07 at 16:47 -0400, Mike Frysinger wrote:
> >> On Thu, Oct 7, 2010 at 16:06, Daniel Walker wrote:
> >> > On Thu, 2010-10-07 at 16:02 -0400, Mike Frysinger wrote:
> >> >> how is that any different from:
> >> >> ln -s ttyJ0 /dev/ttyS0
> >> >
> >> > It has the same major and minors as ttyS* does. So you don't have to run
> >> > anything on the target.
> >>
> >> i dont see how those things are related.  the major/minor are
> >> irrelevant, unless you've already hard coded these in some app that
> >> creates device nodes manually (instead of mdev/udev), but even then
> >> that's something that "needs to be run on the target".  and both
> >> already have config support to transparently do something like
> >> "symlink ttyS# to XXX" as XXX is created.
> >
> > Something does ultimately run on all targets, the issues is does the
> > person debugging have the ability to change it .. It's not always the
> > case that they can change it. The userspace may not have udev at all.
> > The userspace may consist of a single binary .. I'm not making any
> > assumptions about the userspace here, it can be anything.
> 
> then there is already a static rootfs with pre-populated /dev which
> would be fixed, or the single binary fixed.  if the options are "my
> system works" or "my system doesnt work", i cant imagine people would
> continue to attempt to use "/dev/ttyS#" if it didnt exist or didnt
> work.

Ideally you would want this driver to work in any situation .. If it's
setup to use ttyS0 for debugging, even if it doesn't exist, then this
driver would be able to stand in for that interface.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

