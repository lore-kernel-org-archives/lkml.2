Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab1CRJlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 05:41:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50328 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab1CRJlB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 05:41:01 -0400
Subject: Re: [PATCH RESEND v5 -tip] x86, dumpstack: Correct stack dump info
 when frame pointer is available
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Soren Sandmann <ssp@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <1300416006-3163-1-git-send-email-namhyung@gmail.com>
References: <1300416006-3163-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Mar 2011 10:40:33 +0100
Message-ID: <1300441233.21794.32.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 11:40 +0900, Namhyung Kim wrote:
> 
> Current stack dump code scans entire stack and check each entry
> contains a pointer to kernel code. If CONFIG_FRAME_POINTER=y it
> could mark whether the pointer is valid or not based on value of
> the frame pointer. Invalid entries could be preceded by '?' sign.
> 
> However this was not going to happen because scan start point was
> always higher than the frame pointer so that they could not meet.
> 
> Commit 9c0729dc8062 ("x86: Eliminate bp argument from the stack
> tracing routines") delayed bp acquisition point, so the bp was
> read in lower frame, thus all of the entries were marked invalid.
> 
> This patch fixes this by reverting above commit while retaining
> stack_frame() helper as suggested by Frederic Weisbecker.
> End result looks like below:
> 
> before:
> [    3.508329] Call Trace:
> [    3.508551]  [<ffffffff814f35c9>] ? panic+0x91/0x199
> [    3.508662]  [<ffffffff814f3739>] ? printk+0x68/0x6a
> [    3.508770]  [<ffffffff81a981b2>] ? mount_block_root+0x257/0x26e
> [    3.508876]  [<ffffffff81a9821f>] ? mount_root+0x56/0x5a
> [    3.508975]  [<ffffffff81a98393>] ? prepare_namespace+0x170/0x1a9
> [    3.509216]  [<ffffffff81a9772b>] ? kernel_init+0x1d2/0x1e2
> [    3.509335]  [<ffffffff81003894>] ? kernel_thread_helper+0x4/0x10
> [    3.509442]  [<ffffffff814f6880>] ? restore_args+0x0/0x30
> [    3.509542]  [<ffffffff81a97559>] ? kernel_init+0x0/0x1e2
> [    3.509641]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
> 
> after:
> [    3.522991] Call Trace:
> [    3.523351]  [<ffffffff814f35b9>] panic+0x91/0x199
> [    3.523468]  [<ffffffff814f3729>] ? printk+0x68/0x6a
> [    3.523576]  [<ffffffff81a981b2>] mount_block_root+0x257/0x26e
> [    3.523681]  [<ffffffff81a9821f>] mount_root+0x56/0x5a
> [    3.523780]  [<ffffffff81a98393>] prepare_namespace+0x170/0x1a9
> [    3.523885]  [<ffffffff81a9772b>] kernel_init+0x1d2/0x1e2
> [    3.523987]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
> [    3.524228]  [<ffffffff814f6880>] ? restore_args+0x0/0x30
> [    3.524345]  [<ffffffff81a97559>] ? kernel_init+0x0/0x1e2
> [    3.524445]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Soren Sandmann <ssp@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Robert Richter <robert.richter@amd.com> 

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Ingo, _please_, pretty _please_ merge this? These wrecked unwinds drive
me up the wall ;-)
