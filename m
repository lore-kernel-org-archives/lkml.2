Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab2KNCD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:03:27 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34257 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab2KNCDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:03:25 -0500
MIME-Version: 1.0
In-Reply-To: <1352858437.18025.47.camel@gandalf.local.home>
References: <20121114013611.5338.15086.stgit@yunodevel> <1352858437.18025.47.camel@gandalf.local.home>
From: David Sharp <dhsharp@google.com>
Date: Tue, 13 Nov 2012 18:03:03 -0800
Message-ID: <CAJL_ekvb89saY9F0F3ip-8xipuuRyJ1_M8hOyThu_0Q2=5sXgA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] kvm/vmx: Output TSC offset
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 6:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2012-11-14 at 10:36 +0900, Yoshihiro YUNOMAE wrote:
>
>> To merge the data like previous pattern, we apply this patch set. Then, we can
>> get TSC offset of the guest as follows:
>>
>> $ dmesg | grep kvm
>> [   57.717180] kvm: (2687) write TSC offset 18446743360465545001, now clock ##
>>                      ^^^^                   ^^^^^^^^^^^^^^^^^^^^            |
>>                      PID                         TSC offset                 |
>>                                                            HOST TSC value --+
>>
>
> Using printk to export something like this is IMO a nasty hack.
>
> Can't we create a /sys or /proc file to export the same thing?

Since the value changes over the course of the trace, and seems to be
part of the context of the trace, I think I'd include it as a
tracepoint.

>
> -- Steve
>
>
