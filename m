Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab1KWPBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:01:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63933 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab1KWPBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:01:00 -0500
MIME-Version: 1.0
In-Reply-To: <1322054283.10119.11.camel@br98xy6r>
References: <1322043068.10119.7.camel@br98xy6r>
	<20111123102214.GA4914@verge.net.au>
	<1322054283.10119.11.camel@br98xy6r>
Date: Wed, 23 Nov 2011 23:01:00 +0800
Message-ID: <CAM_iQpUowWDiX-44n_qud5cb81MfQCzXKiP3sgokkDzzVrE9FA@mail.gmail.com>
Subject: Re: [PATCH v2] kdump: crashk_res init check for /sys/kernel/kexec_crash_size
From: Cong Wang <xiyou.wangcong@gmail.com>
To: holzheu@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, Simon Horman <horms@verge.net.au>,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 9:18 PM, Michael Holzheu
<holzheu@linux.vnet.ibm.com> wrote:
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

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.
