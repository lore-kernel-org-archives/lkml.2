Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab2KVU5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:57:25 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:35350 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131Ab2KVU5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:57:21 -0500
Message-ID: <50AE91AD.1090709@parallels.com>
Date: Fri, 23 Nov 2012 00:57:17 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Amnon Shiloh <u3557@miso.sublimeip.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: vdso && cr (Was: arch_check_bp_in_kernelspace: fix the range
 check)
References: <20121121141627.GB21030@redhat.com> <20121121173043.F0319592076@miso.sublimeip.com> <20121122161238.GA27078@redhat.com>
In-Reply-To: <20121122161238.GA27078@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2012 08:12 PM, Oleg Nesterov wrote:
> On 11/22, Amnon Shiloh wrote:
>>
>> Now however, that "vsyscall" was effectively replaced by vdso, it
>> creates a new problem for me and probably for anyone else who uses
>> some form of checkpoint/restore:
> 
> Oh, sorry, I can't help here. I can only add Cyrill and Pavel, they
> seem to enjoy trying to solve the c/r problems.

Thank you :)

>> Suppose a process is checkpointed because the system needs to reboot
>> for a kernel-upgrade, then restored on the new and different kernel.
>> The new VDSO page may no longer match the new kernel - it could for
>> example fetch data from addresses in the vsyscall page that now
>> contain different things; or in case the hardware also was changed,
>> it may use machine-instructions that are now illegal.

If we could make VDSO entry points not move across the kernels (iow, make
them looks as yet another syscall table) this would help, I suppose.

> Sure. You shouldn't try to save/restore this page(s) directly. But
> I do not really understand why do you need. IOW, I don't really
> understand the problem, it depends on what c/r actually does.

Think about it like this -- you stop a process, then change the kern^w VDSO
page. Everything should work as it used to be :)

>> As I don't mind to forego the "fast" sys_time(), my obvious solution
>> is to disable the vdso for traced processes that may be checkpointed.

This is very poor solution from my POV. Nobody wants to have their applications
work fast only until it's checkpointed.

Thanks,
Pavel
