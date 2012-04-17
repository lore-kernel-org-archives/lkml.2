Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750874Ab2DQTxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:53:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45326 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab2DQTxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:53:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120417194945.GB14663@moon>
References: <20120416225520.GD9756@moon>
	<CAGXu5jKnfOsXGTx8QbKCCH9C9c+szFwi5oA1R99pjCue9kfpWg@mail.gmail.com>
	<20120417191916.GQ1906@moon>
	<20120417194945.GB14663@moon>
Date: Tue, 17 Apr 2012 12:53:17 -0700
X-Google-Sender-Auth: 1ZDF7Dv9ktWlTqPogg2Evoe5nw4
Message-ID: <CAGXu5j+f-M7y2CqiKnRg+jLxTo2oV9cPaJACKc-XJUoSwB8L+A@mail.gmail.com>
Subject: Re: [PATCH c/r -mm] c/r: prctl: Simplify PR_SET_MM on mm::code/data assignment
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 12:49 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> On Tue, Apr 17, 2012 at 11:19:16PM +0400, Cyrill Gorcunov wrote:
> ...
>> > Since this is CAP_SYS_RESOURCE, and mmap_min_addr is CAP_SYS_RAWIO,
>> > how about a lower-bounds check against mmap_min_addr? (We're already
>> > doing the TASK_SIZE upper check, so this additional sanity checking
>> > seems reasonable to me.)
>>
>> I think this is good idea, thanks Kees. I'll check it out.
>
> Updated and tested version is below.
>
>        Cyrill
> ---
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: [PATCH] c/r: prctl: Simplify PR_SET_MM on mm::code/data assignment v2
>
> The mm::start_code, end_code, start_data, end_data members
> are set during startup of executable file and are not changed
> after.
>
> But the program itself might map new executable or/and data areas in
> time so the original values written into mm fields mentioned above
> might not have correspond VMA area at all, thus if one try to
> use this prctl codes without underlied VMA, the error will be
> returned.
>
> Drop this requirement. This shrinks the code and eliminates
> redundant calls to vma_flags_mismatch. The worst thing one can
> do (if say to write some bad values here) -- the weird results
> will be shown in /proc/$pid/statm or in /proc/pid/stat.
>
> Still, assignement of data on stack (such as command line and
> environment variables) requires the underlied VMA to exist.
>
> v2:
>  Also make sure the address being set is greater than mmap_min_addr.
>  Suggested by Kees Cook.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
ChromeOS Security
