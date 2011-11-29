Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab1K2UiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:38:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51745 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1K2Uh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:37:58 -0500
MIME-Version: 1.0
In-Reply-To: <20111129202951.GG1775@moon>
References: <20111129191252.769160532@openvz.org>
	<20111129191638.912537377@openvz.org>
	<20111129201938.GP5169@outflux.net>
	<20111129202951.GG1775@moon>
Date: Tue, 29 Nov 2011 12:37:58 -0800
X-Google-Sender-Auth: ZeuTfh3SrNfL2nGhMpWZ9FzX8As
Message-ID: <CAGXu5j+_Lz3ZpemFFO-XNbsk0d+Zp4JLiHH6XTQCkQaO3PGg_g@mail.gmail.com>
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

On Tue, Nov 29, 2011 at 12:29 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Tue, Nov 29, 2011 at 12:19:38PM -0800, Kees Cook wrote:
>> On Tue, Nov 29, 2011 at 11:12:55PM +0400, Cyrill Gorcunov wrote:
>> > At restore time we need a mechanism to restore those values
>> > back and for this sake PR_SET_MM prctl code is introduced.
>>
>> arg3 needs to be significantly more carefully validated. find_vma() doesn't
>> say that vm_start <= addr, only that vm_end > addr. This effectively
>> bypasses all the vma checks (mmap_min_addr, max process size, etc), with
>> some pretty crazy side-effects, I think.
>
> Yes, I know it needs some more testing, but apart from vma bounds (yup,
> good point with find_vma, I'll fix) I thought about what else should be
> checked? I think VMA prototype should be checked to fit "code", "data"
> templates, ie code should be at least readable and execytable, but what
> about data and stack and brk, should stack be executable? That is the
> point where I've got a bit confused and though putting RFC out might be
> a good idea to collect opinions.

In the most basic sense, it shouldn't be possible to create an mm
state that can't be reached through the normal ELF loader, calls to
mmap(), mprotect(), stack growth, etc. I think it might be worth
examining those paths to see how they're being bounds-checked. (And
note the especially scary handling of the hidden stack guard page.)

-Kees

-- 
Kees Cook
ChromeOS Security
