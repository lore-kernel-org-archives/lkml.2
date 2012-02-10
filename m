Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab2BJQfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:35:23 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64674 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab2BJQfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:35:22 -0500
MIME-Version: 1.0
In-Reply-To: <20120210155753.GA25923@redhat.com>
References: <1328884991-23889-1-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-2-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-3-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-4-git-send-email-vda.linux@googlemail.com> <20120210155753.GA25923@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 10 Feb 2012 17:34:33 +0100
Message-ID: <CAK1hOcMpwminq8+UKS6v5+4-KRT=0muhjp6cSKfsMcDkxW7S2Q@mail.gmail.com>
Subject: Re: [PATCH 3/5] ptrace: make PTRACE_SEIZE set ptrace options
 specified in 'data' parameter
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 4:57 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/10, Denys Vlasenko wrote:
>>
>> @@ -879,7 +890,7 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
>>       }
>>
>>       if (request == PTRACE_ATTACH || request == PTRACE_SEIZE) {
>> -             ret = ptrace_attach(child, request, data);
>> +             ret = ptrace_attach(child, request, addr, data);
>
> There is another caller which should be updated, sys_compat_ptrace().

Drats. I only tested the patch on i386, not on x86-64, and missed it.
Updated patch follows in a minute.

-- 
vda
