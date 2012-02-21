Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab2BUTvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:51:45 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:59316 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113Ab2BUTvn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:51:43 -0500
MIME-Version: 1.0
In-Reply-To: <4F43F54D.50201@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
 <1329696488-16970-31-git-send-email-hpa@zytor.com> <4F42E171.9080005@mit.edu>
 <4F431665.3010004@zytor.com> <CAObL_7Hy8Y0PWrcZdRSGRcEt+aoma7ax4XU44f-gdHEGoWBzTg@mail.gmail.com>
 <4F43D98D.1020406@zytor.com> <CAObL_7GqT-CSB6uBoDvKymodEzUi3tY0DJv0U=xzYbaJS7A1nA@mail.gmail.com>
 <4F43EA83.6020203@zytor.com> <CAObL_7GLnDFkb61jAZEj+9gGTr4FA=8ZFVMxd9Tus4LVVmKjKw@mail.gmail.com>
 <4F43F25E.3030004@zytor.com> <CAObL_7H=M7-wxobKkj+K2fcrpEv0Nfp8=6gV2yvdb2hqxCTAGg@mail.gmail.com>
 <4F43F54D.50201@zytor.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 21 Feb 2012 11:51:23 -0800
X-Google-Sender-Auth: HFv-ZLPlgae977BVZho1oAkgDnM
Message-ID: <CAObL_7FW7qr5cOpB=kcPaQQUgPAebm+WgzevTW8j83WKV3dFDQ@mail.gmail.com>
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

On Tue, Feb 21, 2012 at 11:49 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/21/2012 11:40 AM, Andrew Lutomirski wrote:
>>>
>>> I was having delusions that we could have a task-owned PDT in negative
>>> space, but that would require unsharing the third level, too, which is
>>> just way too messy.
>>
>> I'd like to do that, too, and I'd also like to have a per-cpu
>> kernel-only page in there, but that's even worse.  If we had a
>> separate cr3-like register for negative addresses, life would be good
>> :)
>>
>
> No, that wouldn't help.  The situation is actually quite similar to the
> current situation where we have an unshared fourth level, but since the
> fourth entries are 512G per entry, we would have to push unsharing of
> the kernel address space at least one more level (1G), possibly two
> (2M).  Painful.
>
> The main advantage of a separate cr3 would be that we wouldn't need the
> unshared top level for the kernel side.

Also, as is, if the top level wants to be per-cpu *and* per-task,
that's a big explosion of page tables that all need to stay in sync.

Oh well.

--Andy
