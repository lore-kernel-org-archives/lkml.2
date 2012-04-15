Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab2DOKOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 06:14:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62242 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2DOKOM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 06:14:12 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20120415065401.GA25380@moon>
References: <1330518197-12825-1-git-send-email-gorcunov@openvz.org>
 <1330518197-12825-2-git-send-email-gorcunov@openvz.org> <CAKgNAkgwapZXw5gR_sSGyfufybY52S4qD1MjPDKs+6tBcgFJUg@mail.gmail.com>
 <20120415065401.GA25380@moon>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sun, 15 Apr 2012 22:13:51 +1200
Message-ID: <CAKgNAkjMpjmKCD3oQa7qTeH5gXydDgMj5TjmKKtyXYzV9f--fA@mail.gmail.com>
Subject: Re: [PATCH 1/2] prctl: Add PR_SET_MM option description
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, linux-man@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 6:54 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> On Sun, Apr 15, 2012 at 03:48:18PM +1200, Michael Kerrisk (man-pages) wrote:
>> Cyrill,
>>
>> While reviewing your patch to the prctl() manual page, I noticed the
>> following code inkernel/sys.c::prctl_set_mm():
>>
>>         if (opt != PR_SET_MM_START_BRK && opt != PR_SET_MM_BRK) {
>>                 /* It must be existing VMA */
>>                 if (!vma || vma->vm_start > addr)
>>                         goto out;
>>         }
>>
>> At this point, the code causes an exit with error set to zero (i.e.,
>> success). This looks unintended to me. Is the code correct? I suspect
>> a return of -EFAULT or -ENOMEM is warranted.
>
> Hi Michael, yup, -EINVAL escaped (I think EFAULT or ENOMEM is not really
> good here). I'll fix and send update. Thanks!

For what it's worth (I am no expert), it looks to me as though EFAULT
or ENOMEM is more usual after a failed find_vma(). Furthermore, EINVAL
is already heavily used, so not very informative as an error.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
