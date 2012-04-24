Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab2DXAfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 20:35:08 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51632 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab2DXAfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 20:35:07 -0400
X-AuditID: 9c930197-b7ca1ae0000069e6-6f-4f95f5391a72
Message-ID: <4F95F553.5030301@kernel.org>
Date: Tue, 24 Apr 2012 09:35:31 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Richard Davies <richard@arachsys.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Chris Webb <chris@arachsys.com>
Subject: Re: Over-eager swapping
References: <20120423092730.GB20543@alpha.arachsys.com>
In-Reply-To: <20120423092730.GB20543@alpha.arachsys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 06:27 PM, Richard Davies wrote:

> We run a number of relatively large x86-64 hosts with twenty or so qemu-kvm
> virtual machines on each of them, and I'm have some trouble with over-eager
> swapping on some of the machines. This is resulting in load spikes during the
> swapping and customer reports of very poor response latency from the virtual
> machines which have been swapped out, despite the hosts apparently having
> large amounts of free memory, and running fine if swap is turned off.
> 
> 
> All of the hosts are currently running a 3.1.4 or 3.2.2 kernel and have ksm
> enabled with 64GB of RAM and 2x eight-core AMD Opteron 6128 processors.
> However, we have seen this same problem since 2010 on a 2.6.32.7 kernel and
> older hardware - see http://marc.info/?l=linux-mm&m=128075337008943
> (previous helpful contributors cc:ed here - thanks).
> 
> We have /proc/sys/vm/swappiness set to 0. The kernel config is here:
> http://users.org.uk/config-3.1.4


Although you set swappiness to 0, kernel can swap out anon pages in
current implementation. I think it's a severe problem.

Couldn't this patch help you?
http://permalink.gmane.org/gmane.linux.kernel.mm/74824
It can prevent anon pages's swap out until few page cache remain.

-- 
Kind regards,
Minchan Kim
