Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab2DZSRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:17:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46821 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab2DZSRK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:17:10 -0400
MIME-Version: 1.0
In-Reply-To: <1335456515-18857-1-git-send-email-gorcunov@gmail.com>
References: <1335456515-18857-1-git-send-email-gorcunov@gmail.com>
Date: Thu, 26 Apr 2012 11:17:08 -0700
X-Google-Sender-Auth: uJGHA9hDybsMNS3CfGxqkEwvQYQ
Message-ID: <CAGXu5j++rdN3yi4cRHiWcRTuzRYSbQyRHY5ZOrjGT=p2VG5ijA@mail.gmail.com>
Subject: Re: c/r: prctl: Drop VMA flags test on PR_SET_MM_ stack data assignment
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 9:08 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> From: Cyrill Gorcunov <gorcunov@openvz.org>
>
> With the
>
>  | commit b76437579d1344b612cf1851ae610c636cec7db0
>  | Author: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
>  | Date:   Wed Mar 21 16:34:04 2012 -0700
>  |
>  | procfs: mark thread stack correctly in proc/<pid>/maps
>
> the stack allocated via clone() is marked in /proc/<pid>/maps as
> [stack:%d] thus it might be out of the former mm->start_stack/end_stack
> values (and even has some custom VMA flags set). So to be able to
> restore mm->start_stack/end_stack drop vma flags test, but still
> require the undrlied VMA to exist.
>
> As always note this feature is under CONFIG_CHECKPOINT_RESTORE
> and requires CAP_SYS_RESOURCE to be granted.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

It'd be nice if there was some sensible per-thread kernel record of
where the stack is expected to be. Regardless:

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
