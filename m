Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab1K2Uk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:40:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52058 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab1K2Uk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:40:57 -0500
MIME-Version: 1.0
In-Reply-To: <20111129203714.GH1775@moon>
References: <20111129191252.769160532@openvz.org>
	<20111129191638.912537377@openvz.org>
	<20111129201938.GP5169@outflux.net>
	<20111129202951.GG1775@moon>
	<20111129203714.GH1775@moon>
Date: Tue, 29 Nov 2011 12:40:57 -0800
X-Google-Sender-Auth: BEbgW7SZGioZED4nd8TXVgfzKfk
Message-ID: <CAGXu5jKDLExXWi+_Hjc+8s7FeuDgQdZcPipMH80LQs+tRyJm2A@mail.gmail.com>
Subject: Re: [rfc 3/3] prctl: Add PR_SET_MM codes to tune up mm_struct entires
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 12:37 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Wed, Nov 30, 2011 at 12:29:51AM +0400, Cyrill Gorcunov wrote:
> ...
>> >
>> > arg3 needs to be significantly more carefully validated. find_vma() doesn't
>> > say that vm_start <= addr, only that vm_end > addr. This effectively
>> > bypasses all the vma checks (mmap_min_addr, max process size, etc), with
>> > some pretty crazy side-effects, I think.
>> >
>>
>> Yes, I know it needs some more testing, but apart from vma bounds (yup,
>> good point with find_vma, I'll fix) I thought about what else should be
>> checked? I think VMA prototype should be checked to fit "code", "data"
>> templates, ie code should be at least readable and execytable, but what
>> about data and stack and brk, should stack be executable? That is the
>> point where I've got a bit confused and though putting RFC out might be
>> a good idea to collect opinions.
>
> On the other hands these fields are set up by elf hanlder code, which
> does mmap these areas, so we have to check that particular member
> belongs to existing VMA and never cross user-space area, and together
> with root-only approach would not it be enough? I'm sure missing something
> that is why I'm asking.

Right, if you verify that the addresses are actually inside valid
userspace vmas, that is likely to be right, though there are probably
other things I haven't thought of. The trouble is avoiding vdso, stack
guard page, vsyscall, and anything else that isn't meant for the mm to
have direct access to.

-- 
Kees Cook
ChromeOS Security
