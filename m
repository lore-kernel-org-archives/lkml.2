Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2BUThW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:37:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45068 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab2BUThU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:37:20 -0500
Message-ID: <4F43F25E.3030004@zytor.com>
Date: Tue, 21 Feb 2012 11:37:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, hjl.tools@gmail.com
Subject: Re: [PATCH 30/30] x32: Add x32 VDSO support
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <1329696488-16970-31-git-send-email-hpa@zytor.com> <4F42E171.9080005@mit.edu> <4F431665.3010004@zytor.com> <CAObL_7Hy8Y0PWrcZdRSGRcEt+aoma7ax4XU44f-gdHEGoWBzTg@mail.gmail.com> <4F43D98D.1020406@zytor.com> <CAObL_7GqT-CSB6uBoDvKymodEzUi3tY0DJv0U=xzYbaJS7A1nA@mail.gmail.com> <4F43EA83.6020203@zytor.com> <CAObL_7GLnDFkb61jAZEj+9gGTr4FA=8ZFVMxd9Tus4LVVmKjKw@mail.gmail.com>
In-Reply-To: <CAObL_7GLnDFkb61jAZEj+9gGTr4FA=8ZFVMxd9Tus4LVVmKjKw@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 11:29 AM, Andrew Lutomirski wrote:
>>
>> The vsyscall page shouldn't be mapped for x32 tasks...
> 
> How is that possible?  It lives in the fixmap and is presumably
> visible from any 64-bit code.
> 
> Admittedly, x32 tasks are probably somewhat difficult to trick into
> calling addresses with high bits set, but it's not necessarily
> impossible.
> 

Fair enough, and it's not necessarily all that hard either.

And it's visible even in a 32-bit task, although a 32-bit task has to
switch into 64-bit mode.  Yet another reason the vsyscall page needs to die.

I was having delusions that we could have a task-owned PDT in negative
space, but that would require unsharing the third level, too, which is
just way too messy.

	-hpa
