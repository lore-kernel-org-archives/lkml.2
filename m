Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1C0RoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 13:44:17 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40945 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab1C0RoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 13:44:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wtq+tgwJwXofEpAV5H6u/0iGXJh1HGa2C18vCMvRn5ZqXlI3VBrrWvcY/5jXXREmuZ
         xdzX8FOhQl2x5VtFkxeaqEw9giD21uGxy3d4zc2QZ5tEa6048EHNjFVzW6YrQtpAbosz
         IGkuqc9WdgF9GJ2PgFH3gzD65n3yTzfigTUEE=
MIME-Version: 1.0
In-Reply-To: <AANLkTikyd5GkR_9BUBFeL+Knxd17uozBJoARThVoOrW9@mail.gmail.com>
References: <AANLkTimYXGQ7BSyuQaqNrW8qp4ETiH8if4-8Gt6LmCyA@mail.gmail.com>
	<AANLkTikua-zAss=BRA106EqvmawVMUqk5Sc-J=VjvC+8@mail.gmail.com>
	<AANLkTikyd5GkR_9BUBFeL+Knxd17uozBJoARThVoOrW9@mail.gmail.com>
Date: Sun, 27 Mar 2011 20:44:05 +0300
Message-ID: <AANLkTinXjEvvV+_E8soiT7zE09O_QT6Gfkh7CPh8mV=N@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request
From: Anca Emanuel <anca.emanuel@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 7:00 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> Exactly... should be fixed by something like:
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 7c708a4..6b82632 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -90,7 +90,7 @@ static void pad_len_spaces(struct seq_file *m, int len)
>
>  static void vma_stop(struct proc_maps_private *priv, struct
> vm_area_struct *vma)
>  {
> -       if (vma && vma != priv->tail_vma) {
> +       if (vma && !IS_ERR(vma) && vma != priv->tail_vma) {
>                struct mm_struct *mm = vma->vm_mm;
>                up_read(&mm->mmap_sem);
>                mmput(mm);
>

I tested the patch and works ok now. Thanks Américo Wang !
Without it, I can reproduce the bug.
