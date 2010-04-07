Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0DGJAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 05:00:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47869 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab0DGJAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 05:00:18 -0400
Date: Wed, 7 Apr 2010 11:00:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Rick Sherm <rick.sherm@yahoo.com>
Cc: linux-numa@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Memory policy question for NUMA arch....
Message-ID: <20100407090014.GD18855@one.firstfloor.org>
References: <524835.89860.qm@web114303.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524835.89860.qm@web114303.mail.gq1.yahoo.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 01:46:44PM -0700, Rick Sherm wrote:
> On a NUMA host, if a driver calls __get_free_pages() then 
> it will eventually invoke ->alloc_pages_current(..). The comment 
> above/within alloc_pages_current() says 'current->mempolicy' will be 
> used.So what memory policy will kick-in if the driver is trying to 
> allocate some memory blocks during driver load time(say from probe_one)? System-wide default policy,correct?

Actually the policy of the modprobe or the kernel boot up if built in
(which is interleaving)

> 
> What if the driver wishes to i) stay confined to a 'cpulist' OR ii) use a different mem-policy? How 
> do I achieve this?
> I will choose the 'cpulist' after I am successfuly able to affinitize the MSI-X vectors.

You can do that right now by running numactl ... modprobe ...

Yes there should be probably a better way, like using a policy
based on the affinity of the PCI device.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
