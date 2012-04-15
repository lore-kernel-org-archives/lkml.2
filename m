Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878Ab2DOEAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 00:00:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63254 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2DOEAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 00:00:39 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sun, 15 Apr 2012 16:00:17 +1200
Message-ID: <CAKgNAkjWdy_SYaJsNXUOv7cNL2xwZNW7FCdRsT6wiRFb0dmetw@mail.gmail.com>
Subject: Bad error return after find_vma() in PR_SET_MM code
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, linux-man@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@osdl.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Bother! Resending with corrected subject line (was "[PATCH 1/2]
prctl: Add PR_SET_MM option description")]

Cyrill,

While reviewing your patch to the prctl() manual page, I noticed the
following code in kernel/sys.c::prctl_set_mm():

       if (opt != PR_SET_MM_START_BRK && opt != PR_SET_MM_BRK) {
               /* It must be existing VMA */
               if (!vma || vma->vm_start > addr)
                       goto out;
       }

At this point, the code causes an exit with error set to zero (i.e.,
success). This looks unintended to me. Is the code correct? I suspect
a return of -EFAULT or -ENOMEM is warranted.

Cheers,

Michael

--
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
