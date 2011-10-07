Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102Ab1JGQGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:06:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:57217 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759999Ab1JGQGA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:06:00 -0400
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@redhat.com, ming.m.lin@intel.com,
        robert.richter@amd.com, ravitillo@lbl.gov
Date: Fri, 07 Oct 2011 18:05:38 +0200
In-Reply-To: <20111007150917.GD14482@one.firstfloor.org>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	 <1317912555-9559-8-git-send-email-eranian@google.com>
	 <20111006153229.GJ14482@one.firstfloor.org>
	 <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com>
	 <4E8EE1B6.1030907@hitachi.com> <20111007150917.GD14482@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318003538.398.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 17:09 +0200, Andi Kleen wrote:
> > if (kernel_ip(addr) || !test_tsk_thread_flag(current, TIF_IA32))
> 
> That's not good, a 64bit process can do 32bit syscalls.
> 
> The only fully working way is to check the code segment, unfortunately
> that requires checking the LDT to be fully correct :-(

I can't really be arsed about people doing daft shit like that. The
worst that happens is that their PEBS fixup fails. Honestly if you do
crazy things like that you deserve far far worse.


