Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab0ITJvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 05:51:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab0ITJvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 05:51:40 -0400
Message-ID: <4C972EA6.2070704@redhat.com>
Date: Mon, 20 Sep 2010 11:51:34 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Subject: Re: [PATCH trace-cmd] plugin_kvm: disassemble instructions for kvm_emulate_insn
References: <1284906837-2431-1-git-send-email-avi@redhat.com>
In-Reply-To: <1284906837-2431-1-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/19/2010 04:33 PM, Avi Kivity wrote:
> Override kvm_emulate_insn formatting to use a disassembler to format
> the emulated instruction.  If a disassembler (udis86) is not available,
> fall back to showing the instruction bytes in hex.
>
> Signed-off-by: Avi Kivity<avi@redhat.com>
> ---
>
> Note 1: on top of 'master' with 'trace-cmd-kvm' cherry-picked on top.
>
> Note 2: I get output of the form
>
> ... kvm_emulate_insn:     0:fffff800010527b5: mov $0x0, 0xfffe00b0CAN'T FIND FIELD "guest_rip"
>
> which leads me to believe there is a bug in trace_seq_printf when the input
> to %s is "".
>
>

Note 3: this is not thread safe.  If trace-cmd wants to be (or is) 
multithreaded, we need some kind of plugin context that is passed to all 
plugin methods, which is initialized separately for each thread.

Or we can be lazy and use thread local storage.

-- 
error compiling committee.c: too many arguments to function

