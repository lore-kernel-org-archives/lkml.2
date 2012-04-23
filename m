Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2DWJet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:34:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42183 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab2DWJer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:34:47 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <1187380078.6698.448.camel@violet>
References: <1187380078.6698.448.camel@violet>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 23 Apr 2012 21:34:27 +1200
Message-ID: <CAKgNAkgJYjACsoOKhFZirPW_SrZ9Rwn7MMch_1GbrrNWFxhu+w@mail.gmail.com>
Subject: Re: [PATCH] Reset current->pdeath_signal on SUID binary execution
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, mtk-manpages@gmx.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel,

On Sat, Aug 18, 2007 at 7:47 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Linus,
>
> the attached patch fixes a flaw in the "parent process death signal"
> when executing SUID binaries. An unprivileged user may send arbitrary
> signal to a child process even if it is running with higher privileges.
>
> The idea to fix this issue is to reset pdeath_signal not only on fork,
> but also on the execution of a SUID binary.
>
> Michael, if we fix it this way, then the prctl() manual page should
> reflect that behavior.

For man-pages-3.40, I applied the patch below.

Cheers,

Michael

--- a/man2/prctl.2
+++ b/man2/prctl.2
@@ -220,7 +220,9 @@ in the range 1..maxsig, or 0 to clear).
 This is the signal that the calling process will get when its
 parent dies.
 This value is cleared for the child of a
-.BR fork (2).
+.BR fork (2)
+and (since Linux 2.5.36 / 2.6.23)
+when execing a set-user_ID or set-group-ID binary.
 .TP
 .BR PR_GET_PDEATHSIG " (since Linux 2.3.15)"
 Return the current value of the parent process death signal,


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
