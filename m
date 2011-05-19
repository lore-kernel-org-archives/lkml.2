Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1ESL2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:28:15 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41083 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1ESL2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:28:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QGecV1KYJ3fGsE14E/82x54OcL2Irjib3U8Pwjuyft+LxFc7CZSv6EvW40UOKleH04
         MVFN9MX6dRX24w6UrQmAXXwZ/G4QU5b+rEj8glznFGhJuEUCDuQY6pkxhPmTOo1aa5R3
         tqpL+UzdEAqebShqqDNvS0hg2KvjZT6XAVmuM=
MIME-Version: 1.0
In-Reply-To: <20110519143213.094da1eb@wks1198.krista.ru>
References: <20110519143213.094da1eb@wks1198.krista.ru>
Date: Thu, 19 May 2011 14:27:42 +0300
Message-ID: <BANLkTinZCvvi88u9WaKKdgmRUv63mkg54Q@mail.gmail.com>
Subject: Re: Some patches for ppp_generic.c and proc/base.c
From: Alexey Dobriyan <adobriyan@gmail.com>
To: samsonov@krista.ru
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/19  <samsonov@krista.ru>:
> I mean that /proc file permission for process information must be
> secure:

And how exactly adding -w------- bit helps this?

> --- ./linux-2.6.33.4.orig/fs/proc/base.c
> +++ ./linux-2.6.33.4/fs/proc/base.c

2.6.39 was released today.

Never, ever mix several patches in one email.

> @@ -2570,11 +2570,11 @@
>  static const struct inode_operations proc_task_inode_operations;
>
>  static const struct pid_entry tgid_base_stuff[] = {
> -       DIR("task",       S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
> -       DIR("fd",         S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
> -       DIR("fdinfo",     S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
> +       DIR("task",       S_IWUSR|S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
> +       DIR("fd",         S_IWUSR|S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
> +       DIR("fdinfo",     S_IRUSR|S_IWUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
>  #ifdef CONFIG_NET
> -       DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
> +       DIR("net",        S_IRUGO|S_IWUSR|S_IXUGO, proc_net_inode_operations, proc_net_operations),
>  #endif
>        REG("environ",    S_IRUSR, proc_environ_operations),
>        INF("auxv",       S_IRUSR, proc_pid_auxv),
> @@ -2608,7 +2608,7 @@
>        REG("pagemap",    S_IRUSR, proc_pagemap_operations),
>  #endif
>  #ifdef CONFIG_SECURITY
> -       DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
> +       DIR("attr",       S_IRUGO|S_IWUSR|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
>  #endif
>  #ifdef CONFIG_KALLSYMS
>        INF("wchan",      S_IRUGO, proc_pid_wchan),
> @@ -2767,7 +2767,7 @@
>        if (!inode)
>                goto out;
>
> -       inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
> +       inode->i_mode = S_IFDIR|S_IRUSR|S_IWUSR|S_IXUSR|S_IRGRP|S_IXGRP;
>        inode->i_op = &proc_tgid_base_inode_operations;
>        inode->i_fop = &proc_tgid_base_operations;
>        inode->i_flags|=S_IMMUTABLE;
> @@ -2909,8 +2909,8 @@
>  * Tasks
>  */
>  static const struct pid_entry tid_base_stuff[] = {
> -       DIR("fd",        S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
> -       DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
> +       DIR("fd",        S_IRUSR|S_IWUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
> +       DIR("fdinfo",    S_IRUSR|S_IWUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
>        REG("environ",   S_IRUSR, proc_environ_operations),
>        INF("auxv",      S_IRUSR, proc_pid_auxv),
>        ONE("status",    S_IRUGO, proc_pid_status),
> @@ -2942,7 +2942,7 @@
>        REG("pagemap",    S_IRUSR, proc_pagemap_operations),
>  #endif
>  #ifdef CONFIG_SECURITY
> -       DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
> +       DIR("attr",      S_IRUGO|S_IWUSR|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
>  #endif
>  #ifdef CONFIG_KALLSYMS
>        INF("wchan",     S_IRUGO, proc_pid_wchan),
> @@ -3008,7 +3008,7 @@
>
>        if (!inode)
>                goto out;
> -       inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
> +       inode->i_mode = S_IFDIR|S_IRUSR|S_IWUSR|S_IXUSR|S_IRGRP|S_IXGRP;
>        inode->i_op = &proc_tid_base_inode_operations;
>        inode->i_fop = &proc_tid_base_operations;
>        inode->i_flags|=S_IMMUTABLE;
