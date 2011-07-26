Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab1GZHh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 03:37:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62086 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1GZHhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 03:37:53 -0400
MIME-Version: 1.0
In-Reply-To: <1311630170-26057-19-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com> <1311630170-26057-19-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 26 Jul 2011 09:37:32 +0200
X-Google-Sender-Auth: umPtn9TEv8lO2Lw6fciSBjzNvJ4
Message-ID: <CAO+b5-o1vZLResL9LzquZw5qu50evzfGAXNQ8fU0dVZZ5iX6+Q@mail.gmail.com>
Subject: Re: [PATCH 18/25] dynamic_debug: describe_flags with '=[pmflta_]*'
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 11:42 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> Change describe_flags() to emit '=[pmflta_]+' for current callsite
> flags, or just '=_' when they're disabled.  Having '=' in output
> allows a more selective grep expression, in contrast '-' may appear
> in filenames, line-ranges, and format-strings.  '=' also has better
> mnemonics, saying; "the current setting are equal to <flags>".
>
> The default allows grep "=_" <dbgfs>/dynamic_debug/control
> to see disabled callsites while avoiding the many occurrences of " = "
> seen in format strings.
>
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  lib/dynamic_debug.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index 396ffb4..37f9748 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -92,6 +92,7 @@ static struct { unsigned flag:8; char opt_char; } opt_array[] = {
>        { _DPRINTK_FLAGS_INCL_LINENO, 'l' },
>        { _DPRINTK_FLAGS_INCL_TID, 't' },
>        { _DPRINTK_FLAGS_APPEND, 'a' },
> +       { _DPRINTK_FLAGS_DEFAULT, '_' },
>  };
>
>  /* format a string into buf[] which describes the _ddebug's flags */
> @@ -102,11 +103,12 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
>        int i;
>
>        BUG_ON(maxlen < 4);
> +       *p++ = '=';
>        for (i = 0; i < ARRAY_SIZE(opt_array); ++i)
>                if (dp->flags & opt_array[i].flag)
>                        *p++ = opt_array[i].opt_char;
> -       if (p == buf)
> -               *p++ = '-';
> +       if (*(p-1) == '=')
> +               *p++ = '_';
>        *p = '\0';
>
>        return buf;

The "BUG_ON(maxlen < 4)" tests whether a buffer overflow can occur
before starting to write in the buffer. Since the above code affects
the number of characters that can be written in the output buffer,
shouldn't that statement be updated or replaced ?

Bart.
