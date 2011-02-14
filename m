Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1BNAul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 19:50:41 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41835 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab1BNAuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 19:50:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 14 Feb 2011 09:44:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: jacob.jun.pan@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arjan van de Ven <arjan@linux.intel.com>,
        container cgroup <containers@lists.linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        akpm@linux-foundation.org, rdunlap@xenotime.net,
        Cedric Le Goater <clg@vnet.ibm.com>
Subject: Re: [PATCH 1/1, v7] cgroup/freezer: add per freezer duty ratio
 control
Message-Id: <20110214094402.4eefe70d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110212232907.GN16432@count0.beaverton.ibm.com>
References: <1297451444-15277-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<20110212232907.GN16432@count0.beaverton.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Feb 2011 15:29:07 -0800
Matt Helsley <matthltc@us.ibm.com> wrote:

> On Fri, Feb 11, 2011 at 11:10:44AM -0800, jacob.jun.pan@linux.intel.com wrote:
> > From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > 
> > Freezer subsystem is used to manage batch jobs which can start
> > stop at the same time. However, sometime it is desirable to let
> > the kernel manage the freezer state automatically with a given
> > duty ratio.
> > For example, if we want to reduce the time that backgroup apps
> > are allowed to run we can put them into a freezer subsystem and
> > set the kernel to turn them THAWED/FROZEN at given duty ratio.
> > 
> > This patch introduces two file nodes under cgroup
> > freezer.duty_ratio_pct and freezer.period_sec
> 
> Again: I don't think this is the right approach in the long term.
> It would be better not to add this interface and instead enable the
> cpu cgroup subsystem for non-rt tasks using a similar duty ratio
> concept..
> 
> Nevertheless, I've added some feedback on the code for you here :).
> 

AFAIK, there was a work for bandwidth control in CFS.

http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-10/msg04335.html

I tested this and worked fine. This schduler approach seems better for
my purpose to limit bandwidth of apprications rather than freezer.

BTW, isn't period_sec too large ? 

Thanks,
-Kame

