Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab1ALK35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 05:29:57 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58052 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1ALK3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 05:29:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bO4o720xb+S36ESA381SeUtZjo6Jm119Z2zh26GpulhsvJmhI+KY2/L9TM2nz0MRzq
         v9mlr3d7R/c9fULQBatA2pUqETZkM2LET0lig2aULCKt0zkyMBLkmJhBfyOT2M/tDlx4
         F9LufhwL8lvb8I7YPD9n2W/F41zo/qd3qt/Xg=
MIME-Version: 1.0
In-Reply-To: <AANLkTikQMrE4eiyEq8fNb2taM+VFN3_fqkrpfYADfcCg@mail.gmail.com>
References: <AANLkTikQMrE4eiyEq8fNb2taM+VFN3_fqkrpfYADfcCg@mail.gmail.com>
Date: Wed, 12 Jan 2011 12:29:54 +0200
Message-ID: <AANLkTikcOeow+O4QUNWLwGprgQR0QgopaUgH-0pCDoQg@mail.gmail.com>
Subject: Re: [PATCH] proc: proc_inode pid/fd and sysctl/sysctl_entry are never
 used at the same time
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Vlad Dogaru <ddvlad@rosedu.org>,
        Octavian Purdila <opurdila@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 12:14 PM, Lucian Adrian Grijincu
<lucian.grijincu@gmail.com> wrote:
> Or at least I could not find a place where both are
> used at the same time.

See proc_evict_inode().

>  struct proc_inode {
> -       struct pid *pid;
> -       int fd;
> -       union proc_op op;
> +       union {
> +               struct {
> +                       int fd;
> +                       struct pid *pid;
> +               };
> +               struct {
> +                       struct ctl_table_header *sysctl;
> +                       struct ctl_table *sysctl_entry;
> +               };
> +       };
>         struct proc_dir_entry *pde;
> -       struct ctl_table_header *sysctl;
> -       struct ctl_table *sysctl_entry;
> +       union proc_op op;
>         struct inode vfs_inode;
>  };
