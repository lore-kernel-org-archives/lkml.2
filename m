Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2DOGyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 02:54:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46067 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab2DOGyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 02:54:07 -0400
Date: Sun, 15 Apr 2012 10:54:01 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, linux-man@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] prctl: Add PR_SET_MM option description
Message-ID: <20120415065401.GA25380@moon>
References: <1330518197-12825-1-git-send-email-gorcunov@openvz.org>
 <1330518197-12825-2-git-send-email-gorcunov@openvz.org>
 <CAKgNAkgwapZXw5gR_sSGyfufybY52S4qD1MjPDKs+6tBcgFJUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkgwapZXw5gR_sSGyfufybY52S4qD1MjPDKs+6tBcgFJUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 03:48:18PM +1200, Michael Kerrisk (man-pages) wrote:
> Cyrill,
> 
> While reviewing your patch to the prctl() manual page, I noticed the
> following code inkernel/sys.c::prctl_set_mm():
> 
>         if (opt != PR_SET_MM_START_BRK && opt != PR_SET_MM_BRK) {
>                 /* It must be existing VMA */
>                 if (!vma || vma->vm_start > addr)
>                         goto out;
>         }
> 
> At this point, the code causes an exit with error set to zero (i.e.,
> success). This looks unintended to me. Is the code correct? I suspect
> a return of -EFAULT or -ENOMEM is warranted.

Hi Michael, yup, -EINVAL escaped (I think EFAULT or ENOMEM is not really
good here). I'll fix and send update. Thanks!

	Cyrill
