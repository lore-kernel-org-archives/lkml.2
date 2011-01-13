Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab1AMU24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:28:56 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:1636 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab1AMU2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:28:50 -0500
X-Greylist: delayed 1525 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jan 2011 15:28:50 EST
Subject: Re: [PATCH 6/6] avr32: deal with double restarts
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <E1PSom6-0008UE-DQ@ZenIV.linux.org.uk>
References: <E1PSom6-0008UE-DQ@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Thu, 13 Jan 2011 21:28:37 +0100
Message-ID: <1294950517.26709.22.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jan 2011 20:28:37.0903 (UTC) FILETIME=[757511F0:01CBB360]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 10:39 +0000, Al Viro wrote:

Hi Al,

> a) take handling of reschedule, signals and keychains into a new helper -
> work_pending().  All looping is done there now; asm glue calls that if
> we have anything for it to do.
> 
> b) do_signal() gets explicit "may restart" flag as an argument; after
> the first call during that loop it gets unconditional 0.
> 
> c) sigreturn() sets a thread flag - TIF_NORESTART.  It is included into
> the "work_pending() has something to do" mask.  work_pending() clears
> it, clearing its may_restart flag if it had done so.

Testing this patch series on top of the latest kernel release it bombs
out quite early with a

Bus error at physical address 0x6c6110e4 (read access)
DTLB dump:
(...)

Do you have any additional information I might have overlooked? On what
hardware and how have you tested this?

<snipp patch>

> -asmlinkage void do_notify_resume(struct pt_regs *regs, struct thread_info *ti)
> +asmlinkage int work_pending(struct pt_regs *regs, struct thread_info *ti, int may_restart)

This line could be broken into two lines be within width limits, and in
addition the work_pending name conflicts with the work_pending macro in
workqueue.h.

<snipp>

-- 
Hans-Christian Egtvedt

