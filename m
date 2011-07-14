Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab1GNWqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 18:46:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56323 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279Ab1GNWqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 18:46:50 -0400
Message-ID: <4E1F7193.80209@zytor.com>
Date: Thu, 14 Jul 2011 15:45:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
References: <1310675693-9204-1-git-send-email-mikew@google.com> <1310675693-9204-2-git-send-email-mikew@google.com> <20110714153113.31ffdeea.akpm@linux-foundation.org> <4E1F6F32.7040504@zytor.com> <CAGTjWtCL-4kqHdQsKHTwCC58y9nqHsJXqxpyygRi3qFvUsqVWw@mail.gmail.com>
In-Reply-To: <CAGTjWtCL-4kqHdQsKHTwCC58y9nqHsJXqxpyygRi3qFvUsqVWw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 03:40 PM, Mike Waychison wrote:
> On Thu, Jul 14, 2011 at 3:35 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 07/14/2011 03:31 PM, Andrew Morton wrote:
>>>
>>> sys_iopl() is missing asmlinkage.
>>>
>>> It would be far more conventional to use cond_syscall().  Perhaps by
>>> adding a CONFIG_X86 area into kernel/sys_ni.c
>>>
>>> fyi, I'm offering special deals on checkpatch.pl site licenses this month.
>>
>> Again, I don't think this makes sense as a compile-time-only option.
> 
> echo "enabled" > /proc/sys/kernel/iopl_available
> echo "disabled" > /proc/sys/kernel/iopl_available
> echo "locked" > /proc/sys/kernel/iopl_available
> 

I'm suspecting that it might be cleaner to have kernel/ioaccess and
kernel/ioaccess_lock as two booleans (0 or 1)...

	-hpa
