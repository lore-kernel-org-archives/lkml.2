Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab0IZJgC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 05:36:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135Ab0IZJgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 05:36:00 -0400
Message-ID: <4C9F13FA.9030405@redhat.com>
Date: Sun, 26 Sep 2010 11:35:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Subject: Re: [PATCH trace-cmd] plugin_kvm: disassemble instructions for kvm_emulate_insn
References: <1284906837-2431-1-git-send-email-avi@redhat.com> <1285298684.31083.6.camel@gandalf.stny.rr.com>
In-Reply-To: <1285298684.31083.6.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/24/2010 05:24 AM, Steven Rostedt wrote:
>   >
> >  Note 2: I get output of the form
> >
> >  ... kvm_emulate_insn:     0:fffff800010527b5: mov $0x0, 0xfffe00b0CAN'T FIND FIELD "guest_rip"
> >
> >  which leads me to believe there is a bug in trace_seq_printf when the input
> >  to %s is "".
>
> I ran this under gdb (nice to do that, where I don't in kernel :-)  And
> it takes me to kvm_emulate_insn_handler() which does the
> trace_seq_printf() fine, but then calls pevent_print_num_field() and
> that passes in "guest_rip" where we get the "CAN'T FIND FIELD" error.
>
> In pevent_print_num_field() it searches for "guest_rip" at the top of
> the function (pevent_find_field()), but the event kvm_emulate_insn does
> not have a "guest_rip" field, then it jumps to the error message.
>
>

Gah, what idiot used copy-paste there?

I'll post a patch to remove that line.

-- 
error compiling committee.c: too many arguments to function

