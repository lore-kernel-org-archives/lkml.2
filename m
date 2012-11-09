Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab2KISa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 13:30:59 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45680 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab2KISax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 13:30:53 -0500
MIME-Version: 1.0
In-Reply-To: <1352467863-1371-1-git-send-email-dedekind1@gmail.com>
References: <1352467863-1371-1-git-send-email-dedekind1@gmail.com>
Date: Fri, 9 Nov 2012 10:30:52 -0800
X-Google-Sender-Auth: l6Sl5S7VX3TiLo-AiwXIXulH1sQ
Message-ID: <CAGXu5j+ODDgH63xyWwYOQFLLe7xsoqYaf5MxnjjPPVKSn7mtFQ@mail.gmail.com>
Subject: Re: [PATCH] proc: pid/status: show all supplementary groups
From: Kees Cook <keescook@chromium.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 5:31 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>
> We display a list of supplementary group for each process in the
> /proc/<pid>/status. However, we show only the first 32 groups, not all of them.
>
> Although this is rare, but sometimes processes do have more than 32
> supplementary groups, and this kernel limitation breaks user-space apps
> that rely on the group list in /proc/<pid>/status.
>
> Number 32 comes from the internal NGROUPS_SMALL macro which defines the
> length for the internal kernel "small" groups buffer. There is no apparent
> reason to limit to this value.
>
> This patch removes the 32 groups printing limit.
>
> The Linux kernel limits the amount of supplementary groups by NGROUPS_MAX,
> which is currently set to 65536. And this is the maximum count of groups we
> may possibly print.
>
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Acked-by: Kees Cook <keescook@chromium.org>

> Cc: stable@vger.kernel.org
> ---
>  fs/proc/array.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> NOTE: I consider this to be a bug which breaks user-space, so I add -stable.

I'm not sure if this will fly since it's been broken for a very long
time, but it's a tiny change.

-Kees

-- 
Kees Cook
Chrome OS Security
