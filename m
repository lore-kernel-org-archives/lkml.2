Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab1LOHG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:06:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53408 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab1LOHG5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:06:57 -0500
MIME-Version: 1.0
In-Reply-To: <20111215064817.GB14237@elte.hu>
References: <20111215004311.GA11049@www.outflux.net>
	<20111215064817.GB14237@elte.hu>
Date: Wed, 14 Dec 2011 23:06:56 -0800
X-Google-Sender-Auth: 9dk5Yl2iJFBG32HEIf5Uyfqhrhk
Message-ID: <CAGXu5jJ4enHVmrdsVK-gpE9RpXfjB7+s5+xRci6KQEhTGGed3g@mail.gmail.com>
Subject: Re: [PATCH v2011.2] fs: symlink restrictions on sticky directories
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>,
        Federica Teodori <federica.teodori@googlemail.com>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 10:48 PM, Ingo Molnar <mingo@elte.hu> wrote:

> * Kees Cook <keescook@chromium.org> wrote:
>
>> +             ab = audit_log_start(current->audit_context,
>> +                                  GFP_ATOMIC, AUDIT_AVC);
>
> Hm, is GFP_ATOMIC really necessary here? Why not GFP_KERNEL?
> This is in VFS process context, not in some atomic context that
> has to be careful about allocations, right?

Hm, that's true. I had started from the lsm_audit interface, but had
to expand it, and in the process copied its use of audit_log_start().
But yeah, I don't see a reason it can't be GFP_KERNEL. I'll adjust it.

Thanks!

-Kees

-- 
Kees Cook
ChromeOS Security
