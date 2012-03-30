Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620Ab2C3Aov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 20:44:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:38906 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2C3Aoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 20:44:46 -0400
Subject: Re: [RFC 00/15] perf: Add backtrace post dwarf unwind
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        rostedt@goodmis.org, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
In-Reply-To: <CABPqkBQfy0CgSiDZ+KXd4fP9XxDxPTipyGbABZdEuTu4LkrsRQ@mail.gmail.com>
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
	 <CABPqkBR7-JreB8c3Y1rNGpqdjeSN71qUkPrMxV-wjOSaTEx+vQ@mail.gmail.com>
	 <1333065559.2960.8.camel@laptop>
	 <CABPqkBQfy0CgSiDZ+KXd4fP9XxDxPTipyGbABZdEuTu4LkrsRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Mar 2012 02:44:39 +0200
Message-ID: <1333068279.2960.20.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-29 at 17:38 -0700, Stephane Eranian wrote:
> What I'd like to have is something similar to:
>     attr->sample_type |= PERF_SAMPLE_REGS
>     attr->sample_regs = EAX | EBX | EDI | ESI |.....
>     attr->sample_reg_mode = { INTR, PRECISE, USER }
> 
> Then in each sample for the event you dump the u64 values
> of the requested registers.  The order is that of the enum
> enum regs {}. That enum is arch specific.
> 
> When you are in precise mode on Intel, you extract the regs
> from PEBS. You already know the registers supported by PEBS
> so you can reject any request for  unsupported regs.
> 
> When you are in intr they you get the regs from pt_regs.
> The user mode case is taken care of by the this patch series
> already.
> 
> I am not sure the sample_reg_mode needs to be a bitmask, i.e.,
> do we need the reg state for INTR+PRECISE or USER+INTR?
> But if so, then we would need attr->sample_regs[3] as not all
> registers may be available in each mode. 

I'm really having trouble seeing how useful this is. You mentioned
sampling function arguments, but most samples would be in the middle of
functions where the regs are completely unrelated to arguments. Also
isn't the 'normal' C ABI passing args on stack rather than registers?



