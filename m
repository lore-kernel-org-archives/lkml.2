Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2BUQwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 11:52:42 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:64886 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942Ab2BUQwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 11:52:40 -0500
MIME-Version: 1.0
In-Reply-To: <4F431665.3010004@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
 <1329696488-16970-31-git-send-email-hpa@zytor.com> <4F42E171.9080005@mit.edu> <4F431665.3010004@zytor.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 21 Feb 2012 08:52:20 -0800
X-Google-Sender-Auth: zU6sBsL3VQKO-dxIja8RzlZXXe8
Message-ID: <CAObL_7Hy8Y0PWrcZdRSGRcEt+aoma7ax4XU44f-gdHEGoWBzTg@mail.gmail.com>
Subject: Re: [PATCH 30/30] x32: Add x32 VDSO support
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, hjl.tools@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 7:58 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/20/2012 04:12 PM, Andy Lutomirski wrote:
>>
>> Would it make sense to remove the non-__vdso-prefixed weak symbols?
>> AFAICT they are somewhere between useless (because the __vdso symbols
>> are unambiguous), confusing (has anyone not read this and said "huh?"),
>> and wrong (they are not interchangeable with glibc's symbols as they
>> return different values).
>>
>> We're stuck with them on x86-64, but x32 is new and has no
>> backwards-compatibility issues.
>>
>
> What about non-glibc?

IMO non-glibc users should just call __vdso_clock_gettime, etc.
Currently, code like:

if (clock_gettime(whatever) == -1)
  handle_the_error();

is correct when linked against glibc but incorrect when linked
directly against the vdso.

--Andy
