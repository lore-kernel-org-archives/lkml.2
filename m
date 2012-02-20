Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2BTK2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 05:28:13 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55789 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab2BTK2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 05:28:10 -0500
Date: Mon, 20 Feb 2012 15:43:37 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkenisto@us.ibm.com, a.p.zijlstra@chello.nl, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com, acme@infradead.org,
        oleg@redhat.com, tglx@linutronix.de,
        Benjamin Herrenschmidt <benh@au1.ibm.com>,
        Josh Stone <jistone@redhat.com>, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/uprobes] uprobes/core: Clean up,  refactor and
 improve the code
Message-ID: <20120220101337.GE22680@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <tip-ewbwhb8o6navvllsauu7k07p@git.kernel.org>
 <20120220060825.GA22680@linux.vnet.ibm.com>
 <20120220073823.GA30810@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120220073823.GA30810@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022010-5930-0000-0000-00000556C4AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2012-02-20 08:38:23]:

> 
> * Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:
> 
> > The volatiles were added to arch/x86/kernel/kprobes.c because 
> > of commit 7115e3fcf45 and 315eb8a2a1b. The volatiles are 
> > required because gcc 4.6 gave a warning about the asm operand 
> > for test_bit.  So the same were added to 
> > arch/x86/kernel/uprobes.c.
> 
> Seems like a GCC bug - a bogus warning - or does it generate bad 
> code as well?

Yes it is a gcc bug and was fixed by Jakub.
As per Josh, only the first long is output if compiled on the buggy gcc.

> 
> In any case, kprobes.c did it correctly, it added the volatile 
> *and a comment*, pointing out that it's a GCC bug. No such 
> warning was added to uprobes.c, making the volatile look 
> entirely spurious.

okay. 

> 
> So feel free to re-add the volatile in a followup patch, just 
> make sure the GCC workaround nature is documented.
> 
> Thanks,
> 
> 	Ingo
> 

