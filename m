Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2JGQ6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 12:58:34 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44278 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2JGQ61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 12:58:27 -0400
MIME-Version: 1.0
In-Reply-To: <1349603814-1085468-1-git-send-email-avagin@openvz.org>
References: <1349603814-1085468-1-git-send-email-avagin@openvz.org>
Date: Sun, 7 Oct 2012 09:58:26 -0700
X-Google-Sender-Auth: LLnTTL6JiEM_eByTHU4O4sSnSPY
Message-ID: <CAGXu5jL8VvfVu0XN7-HDwGt232ovvUBvjP5CJQt+6A3Jnv_OfQ@mail.gmail.com>
Subject: Re: [PATCH] proc: don't show nonexistent capabilities (v2)
From: Kees Cook <keescook@chromium.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, "Andrew G. Morgan" <morgan@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 7, 2012 at 2:56 AM, Andrew Vagin <avagin@openvz.org> wrote:
> Without this patch it is really hard to interpret a bounding set,
> if CAP_LAST_CAP is unknown for a current kernel.
>
> Non-existant capabilities can not be deleted from a bounding set
> with help of prctl.
>
> E.g.: Here are two examples without/with this patch.
> CapBnd: ffffffe0fdecffff
> CapBnd: 00000000fdecffff
>
> I suggest to hide non-existent capabilities. Here is two reasons.
> * It's logically and easier for using.
> * It helps to checkpoint-restore capabilities of tasks, because tasks
> can be restored on another kernel, where CAP_LAST_CAP is bigger.
>
> v2: Non-existent capabilities can not be removed from creds, because
>     in this case user cannot set all=eip. This patch cleans up non-existent
>     capabilities from content of /proc/pid/status
>
> Cc: Andrew G. Morgan <morgan@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Andrew Vagin <avagin@openvz.org>

Seems sensible to me.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
