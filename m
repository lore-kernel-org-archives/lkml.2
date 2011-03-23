Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab1CWNty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:49:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39511 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab1CWNtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:49:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nOukhL4+A+XKHsQzzI786pv5OLqRznI77hJ+UBD9iXXbHxuqQggiQ0qkA4a6gd9hoy
         9g5xfQ2e45WCyYTAO9+sUUYHZUthu2KSqc4OBuNFjgE+5PBa1SS/4xpfKcFiann/Z3y2
         9E/QU1XG//+fVLx51SfG+ae9mBugfAar7yzW4=
MIME-Version: 1.0
In-Reply-To: <1300887824.14261.130.camel@gandalf.stny.rr.com>
References: <20110323131213.GA25467@elte.hu>
	<1300886997-30781-1-git-send-email-namhyung@gmail.com>
	<1300887824.14261.130.camel@gandalf.stny.rr.com>
Date: Wed, 23 Mar 2011 14:49:01 +0100
Message-ID: <AANLkTikidG=c7KvN4=QfwMwrPR8qCY3v4O7wKd8K8wdT@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/2] vsprintf: introduce %pT format specifier
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/23 Steven Rostedt <rostedt@goodmis.org>:
> On Wed, 2011-03-23 at 22:29 +0900, Namhyung Kim wrote:
>> The %pT format specifier is for stack backtrace. Its handler
>> sprint_trace() does symbol lookup using (address-1) to ensure
>> the address will not point outside of the function.
>>
>> If there is a tail-call to the function marked "noreturn",
>> gcc optimized out the code after the call then causes saved
>> return address points outside of the function (i.e. the start
>> of the next function), so pollutes call trace somewhat.
>> This patch will fix it.
>>
>> before:
>> [   18.345923] Call Trace:
>> [   18.346001]  [<ffffffff812a8502>] panic+0x8c/0x18d
>> [   18.346257]  [<ffffffffa000012a>] deep01+0x0/0x38 [test_panic]  <--- bad
>> [   18.346347]  [<ffffffff81104666>] proc_file_write+0x73/0x8d
>> [   18.346432]  [<ffffffff811000b3>] proc_reg_write+0x8d/0xac
>> [   18.346516]  [<ffffffff810c7d32>] vfs_write+0xa1/0xc5
>> [   18.346603]  [<ffffffff810c7e0f>] sys_write+0x45/0x6c
>> [   18.346801]  [<ffffffff8f02943b>] system_call_fastpath+0x16/0x1b
>>
>> after:
>> [   22.224483] Call Trace:
>> [   22.224569]  [<ffffffff812bce69>] panic+0x8c/0x18d
>> [   22.224848]  [<ffffffffa000012a>] panic_write+0x20/0x20 [test_panic]  <--- ok
>> [   22.224979]  [<ffffffff81115fab>] proc_file_write+0x73/0x8d
>> [   22.225089]  [<ffffffff81111a5f>] proc_reg_write+0x8d/0xac
>> [   22.225199]  [<ffffffff810d90ee>] vfs_write+0xa1/0xc5
>> [   22.225304]  [<ffffffff810d91cb>] sys_write+0x45/0x6c
>> [   22.225408]  [<ffffffff812c07fb>] system_call_fastpath+0x16/0x1b
>
> Nice
>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Same for me:

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
