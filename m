Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2JKUEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:04:30 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:49707 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab2JKUE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:04:29 -0400
MIME-Version: 1.0
In-Reply-To: <1349982438-2062-1-git-send-email-j.glisse@gmail.com>
References: <1349982438-2062-1-git-send-email-j.glisse@gmail.com>
Date: Thu, 11 Oct 2012 16:04:28 -0400
Message-ID: <CAH3drwaFsaS3w6NeHJXNAjEXaYORYS3R3MCOKenYAhzP_bhyeQ@mail.gmail.com>
Subject: Re: [PATCH] coredump: always kill the task no matter what
From: Jerome Glisse <j.glisse@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: roland@redhat.com, Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 3:07 PM,  <j.glisse@gmail.com> wrote:
> From: Jerome Glisse <jglisse@redhat.com>
>
> If do_coredump fails for any reason make sure that the task
> is actualy wakeup and properly kill otherwise we endup with
> zombies task.
>
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> ---
>  fs/coredump.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/coredump.c b/fs/coredump.c
> index fd37fac..4b61468 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -643,11 +643,11 @@ fail_dropcount:
>  fail_unlock:
>         kfree(cn.corename);
>  fail_corename:
> -       coredump_finish(mm);
>         revert_creds(old_cred);
>  fail_creds:
>         put_cred(cred);
>  fail:
> +       coredump_finish(mm);
>         return;
>  }
>
> --
> 1.7.12.1
>

Actually wrong patch, this one does not solve my issue.

Cheers,
Jerome
