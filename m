Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862Ab2CIVwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:52:23 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61600 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758505Ab2CIVwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:52:21 -0500
Date: Sat, 10 Mar 2012 01:52:17 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120309215217.GA725@moon>
References: <20120308165112.GF21812@moon>
 <20120308182623.GA17221@redhat.com>
 <20120308190303.GG21812@moon>
 <20120309214637.GC19584@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309214637.GC19584@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 01:46:37PM -0800, Matt Helsley wrote:
> > > 
> > > I simply do not understand what mm->num_exe_file_vmas means after
> > > PR_SET_MM_EXE_FILE.
> 
> I think it should fail if the num_exe_file_vmas is not 0 when
> PR_SET_MM_EXE_FILE is used. It's simple, keeps things clear, might
> catch userspace bugs (harder to accidentally leave a mapping of the original
> executable), and could avoid kernel bugs too.

Yes, and in last version (whuch I just sent out) we have at the very beginning
of the function

+	if (mm->num_exe_file_vmas)
+               return -EBUSY;

> > 
> > Wait, Oleg, I'm confused, in case if there *is* exitsting VM_EXECUTABLEs
> > then we jump into first banch and simply replace old exe_file.
> 
> What happens if multiple prctl calls are made? We'll have a mix of N
> executable files that've been mapped n_i times. I think we're better off
> just returning an error in that case -- -EBUSY or something.
> 
> > If there is no VM_EXECUTABLEs, then we simply setup new exe_file
> > and num_exe_file_vmas remains zero.
> 
> Which is fine.
> 

Matt, please check the last version, and tell me if it's fine for you.

	Cyrill
