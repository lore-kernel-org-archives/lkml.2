Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab2KZO06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 09:26:58 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:33359 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab2KZO05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 09:26:57 -0500
Subject: Re: vdso && cr (Was: arch_check_bp_in_kernelspace: fix the range
To: gorcunov@openvz.org (Cyrill Gorcunov)
Date: Tue, 27 Nov 2012 01:26:55 +1100 (EST)
Cc: avagin@gmail.com (Andrey Wagin), oleg@redhat.com (Oleg Nesterov),
        xemul@parallels.com (Pavel Emelyanov),
        rostedt@goodmis.org (Steven Rostedt),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra),
        linux-kernel@vger.kernel.org (LKML)
Reply-To: u3557@dialix.com.au
In-Reply-To: <20121126141843.GE10312@moon>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20121126142655.9AD28592064@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

Programmers don't (and the manual-page says they shouldn't even try)
call "sigreturn" directly.

If an interrupt happens, by bad luck, to occur while the process
is running vdso code, then eventually, once signal-processing is
complete, "sigreturn" (issued by  glibc) will take the process back
to where it was before the interrupt happend, inside the vdso page.

Best Regards,
Amnon.

> On Mon, Nov 26, 2012 at 11:55:01PM +1100, Amnon Shiloh wrote:
> > 
> > You could of course keep that old code and modify only the very
> > first instruction of each routine into a jump instruction, but then
> > the code to which the process returns may not be compatible with
> > the new kernel and/or hardware configuration.
> 
> For sure there will be some limitations but I fear we can't do
> that much with it. I don't expect the regular program to use
> sigreturn for jumping into vdso code, but I could be wrong.
> 
> 	Cyrill
> 

