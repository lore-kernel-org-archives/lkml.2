Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab2LOBqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 20:46:22 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49066 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932571Ab2LOBqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 20:46:21 -0500
MIME-Version: 1.0
In-Reply-To: <20121215010312.GA27536@amt.cnet>
References: <CALCETrUf6ZPfXuFsZD32w76CQsrqg42_75cmqeTa9jW+in=41A@mail.gmail.com>
 <20121215010312.GA27536@amt.cnet>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 14 Dec 2012 17:46:00 -0800
Message-ID: <CALCETrXfxQ8eCtF5fu3pYMGY-CGA-tyw3B8TG_4yu+k=qHGMuA@mail.gmail.com>
Subject: Re: percpu allocation failures in kvm
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 5:03 PM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Thu, Dec 13, 2012 at 09:43:23PM -0800, Andy Lutomirski wrote:
>> On 3.7.0 + irrelevant patches, I get this on boot.  I've seen it on
>> and off on earlier kernels, I think (although I'm not currently
>> getting it on 3.5).
>>
>> [   10.230054] PERCPU: allocation failed, size=304 align=32, alloc
>> from reserved chunk failed
>> [   10.230059] Pid: 1026, comm: modprobe Tainted: G        W    3.7.0-ama+ #5
>> [   10.230060] Call Trace:
>> [   10.230070]  [<ffffffff81129efb>] pcpu_alloc+0x9db/0xa40
>> [   10.230074]  [<ffffffff810a81ad>] ? find_symbol_in_section+0x4d/0x140
>> [   10.230077]  [<ffffffff810a8160>] ? finished_loading+0x50/0x50
>> [   10.230080]  [<ffffffff810a8af0>] ? each_symbol_section+0x30/0x70
>> [   10.230083]  [<ffffffff810a8b61>] ? find_symbol+0x31/0x60
>> [   10.230086]  [<ffffffff8112a1f3>] __alloc_reserved_percpu+0x13/0x20
>> [   10.230089]  [<ffffffff810ab48d>] load_module+0x3ed/0x1b50
>> [   10.230093]  [<ffffffff81075c3b>] ? __srcu_read_unlock+0x4b/0x70
>>
>> --Andy
>
> You're loading the kvm module, or loading some other module inside
> a kvm guest?
>

This is loading the kvm module on startup.  There are no guests.

-- 
Andy Lutomirski
AMA Capital Management, LLC
