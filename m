Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab1FVMnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 08:43:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64652 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1FVMnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 08:43:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous Memory Allocator added
Date: Wed, 22 Jun 2011 14:42:20 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        "'Daniel Walker'" <dwalker@codeaurora.org>, linux-mm@kvack.org,
        "'Mel Gorman'" <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-media@vger.kernel.org,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com> <201106150937.18524.arnd@arndb.de> <201106220903.31065.hverkuil@xs4all.nl>
In-Reply-To: <201106220903.31065.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106221442.20848.arnd@arndb.de>
X-Provags-ID: V02:K0:+unuqkcD9EtUr1QTDNiET/xTSl9XddzM0Uo/o3XE68+
 d6ZkKQ4m739ThXb/RdQ1SdlDh4GTjwF0lO0msQTBoP7NdiTfyy
 SjPV+jU/pr4PwpgGMgO02oakJbcFlYo4z+n1YysHZXsk4F+9r0
 vpOoUb/yLgE3GkuARWLvQ0fHzsiwP7bj/+XxZTsNvnN0DvX40X
 IcvuXczx7KDF3tCRgh18Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 June 2011, Hans Verkuil wrote:
> > How about a Kconfig option that defines the percentage of memory
> > to set aside for contiguous allocations?
> 
> I would actually like to see a cma_size kernel option of some sort. This would
> be for the global CMA pool only as I don't think we should try to do anything
> more complicated here.

A command line is probably good to override the compile-time default, yes.

We could also go further and add a runtime sysctl mechanism like the one
for hugepages, where you can grow the pool at run time as long as there is
enough free contiguous memory (e.g. from init scripts), or shrink it later
if you want to allow larger nonmovable allocations.

My feeling is that we need to find a way to integrate the global settings
for four kinds of allocations:

* nonmovable kernel pages
* hugetlb pages
* CMA
* memory hotplug

These essentially fight over the same memory (though things are slightly
different with dynamic hugepages), and they all face the same basic problem
of getting as much for themselves without starving the other three.

	Arnd

