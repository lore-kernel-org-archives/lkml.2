Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab1F1KPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:15:35 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34793 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab1F1KJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:09:07 -0400
MIME-Version: 1.0
In-Reply-To: <1309244992-2305-3-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com> <1309244992-2305-3-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 28 Jun 2011 12:08:46 +0200
X-Google-Sender-Auth: ZbdYwTAqzBJizWt1iZDEf5d0D40
Message-ID: <BANLkTikjrf6kQcobm1hL7DqxK8iJqV5kjw@mail.gmail.com>
Subject: Re: [PATCH 02/11] dynamic_debug: trim source-path prefix from dynamic_debug/control
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, gnb@fmeh.org, jbaron@redhat.com,
        gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 9:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
>
> Skip past unchanging absolute source-path prefix to print a path
> thats relative to kernel source's root-dir.  This makes the file
> easier to read without a wide screen.  For example:
>
> kernel/freezer.c:128 [freezer]cancel_freezing - "  clean up: %s\012"
>
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  lib/dynamic_debug.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index a3b08d5..eb08a2f 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -601,6 +601,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
>        struct ddebug_iter *iter = m->private;
>        struct _ddebug *dp = p;
>        char flagsbuf[8];
> +       const int offset = strlen(__FILE__) - strlen("lib/dynamic_debug.c");
>
>        if (verbose)
>                printk(KERN_INFO "%s: called m=%p p=%p\n",
> @@ -613,7 +614,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
>        }
>
>        seq_printf(m, "%s:%u [%s]%s %s \"",
> -                  dp->filename, dp->lineno,
> +                  dp->filename + offset, dp->lineno,
>                   iter->table->mod_name, dp->function,
>                   ddebug_describe_flags(dp, flagsbuf, sizeof(flagsbuf)));
>        seq_escape(m, dp->format, "\t\r\n\"");

The above will break the output generated for out-of-tree kernel
modules that use the dynamic debug facility.

Bart.
