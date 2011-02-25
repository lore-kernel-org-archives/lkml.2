Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab1BYSZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:25:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:28350 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932097Ab1BYSZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:25:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,226,1297065600"; 
   d="scan'208";a="713331895"
Date: Fri, 25 Feb 2011 10:23:19 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Paul Menage <menage@google.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arjan van de Ven <arjan@linux.intel.com>,
        container cgroup <containers@lists.linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, akpm@linux-foundation.org,
        rdunlap@xenotime.net, Cedric Le Goater <clg@vnet.ibm.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 1/1, v9] cgroup/freezer: add per freezer duty ratio
 control
Message-ID: <20110225102319.6c776838@putvin>
In-Reply-To: <AANLkTinyhp29X8-atA=0DaHFuthTjVMJgBOitP52gwEX@mail.gmail.com>
References: <1297807750-28844-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1297807750-28844-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<201102160100.15487.rjw@sisk.pl>
	<20110215163812.7fa020b5@putvin>
	<20110216032321.GA14893@count0.beaverton.ibm.com>
	<20110224154525.1b463723@jacob-laptop>
	<AANLkTinyhp29X8-atA=0DaHFuthTjVMJgBOitP52gwEX@mail.gmail.com>
Organization: OTC
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011 09:53:59 -0800
Paul Menage <menage@google.com> wrote:

> On Thu, Feb 24, 2011 at 3:45 PM, jacob pan
> <jacob.jun.pan@linux.intel.com> wrote:
> > I played with v3 and v4 of the CFS bandwidth patch. When the cpu
> > cgroup exceeds its cfs_quota, it does have the same effect as this
> > patch in terms of freeze/thaw at given period and allowed runtime.
> > But when the cgroup cpu usage is below cfs_quota, it is not
> > throttled. Therefore, it cannot reduce wakeups.
> 
> How about a userspace daemon that periodically flips the CPU quota for
> the cgroup between zero and the group's runnable level? Wouldn't that
> achieve what you need pretty easily without having to introduce
> additional complexity and threads into the kernel?
I think it should work but with little bit more overhead than
doing the same in the kernel. It will also need one periodic timer per
cgroup. Two extra timer wake ups for each time slice to run.
Thanks for the great suggestion. I will do some experiment with it.
