Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab2BUT3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:29:23 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:32805 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752600Ab2BUT3V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:29:21 -0500
MIME-Version: 1.0
In-Reply-To: <4F43EA83.6020203@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
 <1329696488-16970-31-git-send-email-hpa@zytor.com> <4F42E171.9080005@mit.edu>
 <4F431665.3010004@zytor.com> <CAObL_7Hy8Y0PWrcZdRSGRcEt+aoma7ax4XU44f-gdHEGoWBzTg@mail.gmail.com>
 <4F43D98D.1020406@zytor.com> <CAObL_7GqT-CSB6uBoDvKymodEzUi3tY0DJv0U=xzYbaJS7A1nA@mail.gmail.com>
 <4F43EA83.6020203@zytor.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 21 Feb 2012 11:29:00 -0800
X-Google-Sender-Auth: M9d8TY9nVF72GNUOINuYqZJW3f8
Message-ID: <CAObL_7GLnDFkb61jAZEj+9gGTr4FA=8ZFVMxd9Tus4LVVmKjKw@mail.gmail.com>
Subject: Re: [PATCH 30/30] x32: Add x32 VDSO support
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, hjl.tools@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 11:03 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/21/2012 10:54 AM, Andrew Lutomirski wrote:
>>
>> uclibc hardcodes a call to the vsyscall gettimeofday implementation in
>> its locking primitives, which probably gives terrible performance, but
>> that's a separate issue.  I think do_emulate_vsyscall should send a
>> segfault if called by an x32 task -- there's some security benefit to
>> doing so, and there's unlikely to be any downside.
>>
>
> The vsyscall page shouldn't be mapped for x32 tasks...

How is that possible?  It lives in the fixmap and is presumably
visible from any 64-bit code.

Admittedly, x32 tasks are probably somewhat difficult to trick into
calling addresses with high bits set, but it's not necessarily
impossible.

--Andy
