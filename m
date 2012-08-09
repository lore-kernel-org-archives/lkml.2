Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759663Ab2HIUaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 16:30:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43106 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759531Ab2HIUaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 16:30:00 -0400
Message-ID: <50241DA9.7070108@zytor.com>
Date: Thu, 09 Aug 2012 13:29:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Meredydd Luff <meredydd@senatehouse.org>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [RFC] syscalls,x86: Add execveat() system call (v2)
References: <1343859049-3632-1-git-send-email-meredydd@senatehouse.org> <50240D47.7050906@amacapital.net>
In-Reply-To: <50240D47.7050906@amacapital.net>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 12:19 PM, Andy Lutomirski wrote:
> On 08/01/2012 03:10 PM, Meredydd Luff wrote:
>>  
>> +#ifndef sys_execveat
>> +asmlinkage long sys_execveat(int dfd, const char __user *filename,
>> +			     const char __user *const __user *argv,
>> +			     const char __user *const __user *envp,
>> +			     struct pt_regs *regs);
>> +#endif
> 
> Should this have a flags argument for future extension?
> 

Not just for future extension.  We already have a NOFOLLOW flag for the
-at functions, and that would be applicable here.  CLOEXEC, obviously not ;)

	-hpa



