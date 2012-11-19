Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab2KSWex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 17:34:53 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62232 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab2KSWev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 17:34:51 -0500
MIME-Version: 1.0
In-Reply-To: <1353337961-12962-8-git-send-email-ebiederm@xmission.com>
References: <87lidx8wbo.fsf@xmission.com>
	<1353337961-12962-1-git-send-email-ebiederm@xmission.com>
	<1353337961-12962-8-git-send-email-ebiederm@xmission.com>
Date: Mon, 19 Nov 2012 14:34:50 -0800
X-Google-Sender-Auth: jaRLD_So5yggDcH8uMAF6VTaqeY
Message-ID: <CAGXu5jK+qacMmvoMJ924DLY9GCFXM55wQtqUUDTo08db-LxQ8A@mail.gmail.com>
Subject: Re: [PATCH review 08/16] userns: Kill task_user_ns
From: Kees Cook <keescook@chromium.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Morris <james.l.morris@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 7:12 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
>
> The task_user_ns function hides the fact that it is getting the user
> namespace from struct cred on the task.  struct cred may go away as
> soon as the rcu lock is released.  This leads to a race where we
> can dereference a stale user namespace pointer.
>
> To make it obvious a struct cred is involved kill task_user_ns.
>
> To kill the race modify the users of task_user_ns to only
> reference the user namespace while the rcu lock is held.
>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: James Morris <james.l.morris@oracle.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Nice catch! This is disappointingly messy looking, but I do not see
any sensible way to clean it up better than you've already done.

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
