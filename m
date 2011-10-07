Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab1JGPJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 11:09:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39902 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab1JGPJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 11:09:18 -0400
Date: Fri, 7 Oct 2011 17:09:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, ming.m.lin@intel.com, robert.richter@amd.com,
        ravitillo@lbl.gov
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for Intel X86
Message-ID: <20111007150917.GD14482@one.firstfloor.org>
References: <1317912555-9559-1-git-send-email-eranian@google.com> <1317912555-9559-8-git-send-email-eranian@google.com> <20111006153229.GJ14482@one.firstfloor.org> <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com> <4E8EE1B6.1030907@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8EE1B6.1030907@hitachi.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> if (kernel_ip(addr) || !test_tsk_thread_flag(current, TIF_IA32))

That's not good, a 64bit process can do 32bit syscalls.

The only fully working way is to check the code segment, unfortunately
that requires checking the LDT to be fully correct :-(

In 2.4 we had some code for that if you want to copy, but it disappeared
later.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
