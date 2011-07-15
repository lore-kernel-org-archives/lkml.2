Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426Ab1GOKGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 06:06:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56710 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965286Ab1GOKGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 06:06:10 -0400
MIME-Version: 1.0
In-Reply-To: <3667c0a87dd8fd64fdf1b1e8107b130a9b41096e.1310657068.git.jbaron@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com> <3667c0a87dd8fd64fdf1b1e8107b130a9b41096e.1310657068.git.jbaron@redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 15 Jul 2011 12:05:50 +0200
X-Google-Sender-Auth: Ic4FuH_f0Zy9rf9ZS2u7dsaxR0Q
Message-ID: <CAO+b5-qA3s92YX2izXzvzt3MOrzRaPcZtDtK0cDte0ZXnRWxhA@mail.gmail.com>
Subject: Re: [PATCH 11/11] dynamic_debug: use a single printk() to emit msgs
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, joe@perches.com, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 6:09 PM, Jason Baron <jbaron@redhat.com> wrote:
> +static int dynamic_emit_prefix(const struct _ddebug *descriptor, char *buf)
>  {
>        char tid[sizeof(int) + sizeof(int)/2 + 4];
>        char lineno[sizeof(int) + sizeof(int)/2];
> @@ -442,31 +444,33 @@ static int dynamic_emit_prefix(const struct _ddebug *descriptor)
>        else
>                lineno[0] = 0;
>
> -       return printk(KERN_DEBUG "%s%s%s%s%s%s",
> -                     tid,
> -                     (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME) ?
> -                     descriptor->modname : "",
> -                     (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME) ?
> -                     ":" : "",
> -                     (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME) ?
> -                     descriptor->function : "",
> -                     (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME) ?
> -                     ":" : "",
> -                     lineno);
> +       return snprintf(buf, PREFIX_SIZE, KERN_DEBUG"%s%s%s%s%s%s",
> +                       tid,
> +                       (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME) ?
> +                       descriptor->modname : "",
> +                       (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME) ?
> +                       ":" : "",
> +                       (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME) ?
> +                       descriptor->function : "",
> +                       (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME) ?
> +                       ":" : "", lineno);
>  }

Not that's it important, but this change makes is possible to
eliminate the tid[] and lineno[] arrays again. Has that been
considered ?

Bart.
