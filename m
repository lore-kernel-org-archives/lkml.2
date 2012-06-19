Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab2FSXAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:00:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2FSXAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:00:03 -0400
Date: Tue, 19 Jun 2012 16:00:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pearson, Greg" <greg.pearson@hp.com>
Cc: "tj@kernel.org" <tj@kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "shangw@linux.vnet.ibm.com" <shangw@linux.vnet.ibm.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] mm/memblock: fix overlapping allocation when
 doubling reserved array
Message-Id: <20120619160001.0c58c7be.akpm@linux-foundation.org>
In-Reply-To: <4FE0FE9B.8020401@hp.com>
References: <1340063278-31601-1-git-send-email-greg.pearson@hp.com>
	<20120619151435.10c16aed.akpm@linux-foundation.org>
	<4FE0FE9B.8020401@hp.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2012 22:35:08 +0000
"Pearson, Greg" <greg.pearson@hp.com> wrote:

> On 06/19/2012 04:14 PM, Andrew Morton wrote:
> > On Mon, 18 Jun 2012 17:47:58 -0600
> > Greg Pearson <greg.pearson@hp.com> wrote:
> >
> >> The __alloc_memory_core_early() routine will ask memblock for a range
> >> of memory then try to reserve it. If the reserved region array lacks
> >> space for the new range, memblock_double_array() is called to allocate
> >> more space for the array. If memblock is used to allocate memory for
> >> the new array it can end up using a range that overlaps with the range
> >> originally allocated in __alloc_memory_core_early(), leading to possible
> >> data corruption.
> > OK, but we have no information about whether it *does* lead to data
> > corruption.  Are there workloads which trigger this?  End users who are
> > experiencing problems?
> >
> > See, I (and others) need to work out whether this patch should be
> > included in 3.5 or even earlier kernels.  To do that we often need the
> > developer to tell us what the impact of the bug is upon users.  Please
> > always include this info when fixing bugs.
> 
> Andrew,
> 
> I'm currently working on a prototype system that exhibits the data 
> corruption problem when doubling the reserved array while booting the 
> system. This system will be a released product in the future.

OK.  I guess we can slip this fix into 3.5.  Do you think it should be
backported?  I guess "yes", as you will probably want to run 3.4 or
earlier kernels on that machine.

