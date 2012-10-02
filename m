Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab2JBVlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:41:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37000 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab2JBVlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:41:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJCqABZcMHuQNAaAcUKCEsSqOTn5=DHdwFdJ70zVLsmSQ@mail.gmail.com>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>
	<20120820180037.GV4232@outflux.net>
	<CAKFga-dDRyRwxUu4Sv7QLcoyY5T3xxhw48LP2goWs=avGW0d_A@mail.gmail.com>
	<CAGXu5jJCqABZcMHuQNAaAcUKCEsSqOTn5=DHdwFdJ70zVLsmSQ@mail.gmail.com>
Date: Tue, 2 Oct 2012 23:41:02 +0200
Message-ID: <CAKFga-fB2JSAscSVi+YUOnFS4Lq4yzH5MHRwxDQBQYZfKAgB6A@mail.gmail.com>
Subject: Re: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
From: Ard Biesheuvel <ard.biesheuvel@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/2 Kees Cook <keescook@chromium.org>:
>> If desired, additional restrictions can be imposed by using the
>> security framework, e.g,, disallow non-final r-x mappings.
>
> Interesting; what kind of interface did you have in mind?
>

The 'interface' we use is a LSM .ko which registers handlers for
mmap() and mprotect() that fail the respective invocations if the
passed arguments do not adhere to the policy.

>>> It seems like there needs to be a sensible way to detect that this flag is
>>> available, though.
>>
>> I am open for suggestions to address this. Our particular
>> implementation of the loader (on an embedded system) tries to set it
>> on the first mmap invocation, and stops trying if it fails. Not the
>> most elegant approach, I know ...
>
> Actually, that seems easiest.
>
> Has there been any more progress on this patch over-all?
>

No progress.

-- 
Ard.
