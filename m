Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab1KXALF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 19:11:05 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:48236 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab1KXALD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 19:11:03 -0500
Date: Thu, 24 Nov 2011 09:10:58 +0900
From: Simon Horman <horms@verge.net.au>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2] kdump: crashk_res init check for
 /sys/kernel/kexec_crash_size
Message-ID: <20111124001058.GB10562@verge.net.au>
References: <1322043068.10119.7.camel@br98xy6r>
 <20111123102214.GA4914@verge.net.au>
 <1322054283.10119.11.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322054283.10119.11.camel@br98xy6r>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 02:18:03PM +0100, Michael Holzheu wrote:
> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> Currently it is possible to set the crash_size via the sysfs
> /sys/kernel/kexec_crash_size even if no crash kernel memory has
> been defined with the "crashkernel" parameter. In this case
> "crashk_res" is not initialized and crashk_res.start = crashk_res.end = 0.
> Unfortunately resource_size(&crashk_res) returns 1 in this case.
> This breaks the s390 implementation of crash_(un)map_reserved_pages().
> 
> To fix the problem the correct "old_size" is now calculated in
> crash_shrink_memory(). "old_size is set to "0" if crashk_res is
> not initialized. With this change crash_shrink_memory() will do nothing,
> when "crashk_res" is not initialized. It will return "0" for
> "echo 0 > /sys/kernel/kexec_crash_size" and -EINVAL for
> "echo [not zero] > /sys/kernel/kexec_crash_size".
> 
> In addition to that this patch also simplifies the "ret = -EINVAL"
> vs. "ret = 0" logic as suggested by Simon Horman.
> 
> Cc: Simon Horman <horms@verge.net.au>
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Thanks Michael,

Reviewed-by: Simon Horman <horms@verge.net.au>
