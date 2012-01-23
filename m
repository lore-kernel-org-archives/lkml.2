Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab2AWSyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:54:55 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60880 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab2AWSyy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:54:54 -0500
MIME-Version: 1.0
In-Reply-To: <20120123142436.181674896@openvz.org>
References: <20120123142036.025893883@openvz.org>
	<20120123142436.181674896@openvz.org>
Date: Mon, 23 Jan 2012 10:54:53 -0800
X-Google-Sender-Auth: fM9df1KgiPhORgCaf7gG6KsoXSA
Message-ID: <CAGXu5j+JrntZcr1sZ1sHXmOTT5jCuMp5HUQnucHqEgF+LXX5VA@mail.gmail.com>
Subject: Re: [patch 1/4] fs, proc: Introduce /proc/<pid>/task/<tid>/children
 entry v8
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 6:20 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> When we do checkpoint of a task we need to know the list of children
> the task, has but there is no easy and fast way to generate reverse
> parent->children chain from arbitrary <pid> (while a parent pid is
> provided in "PPid" field of /proc/<pid>/status).
> [...]
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

> +static int children_seq_show(struct seq_file *seq, void *v)
> +{
> +       struct inode *inode = seq->private;
> +       pid_t pid;
> +
> +       pid = pid_nr_ns(v, inode->i_sb->s_fs_info);
> +       return seq_printf(seq, " %d", pid);
> +}

Does this mean the file contents always starts with a space? I think
I'd prefer a trailing space than a leading one. Better yet, neither.
:)

-Kees

-- 
Kees Cook
ChromeOS Security
