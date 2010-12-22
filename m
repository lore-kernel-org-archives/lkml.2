Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0LVNOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:14:50 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38698 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab0LVNOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:14:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=Mmpy0acRVDiUYFSwLN5WG9kHz4p/g94m9p2tkoJjKdRQqZ/FP2m+j9BJP2gMawLY45
         7jgHEZwFEU967W0jjngpD/ULxZrYI7DU2t2rH3oFpjN5sW/FKxX32CDdwnHyV0WUCtU0
         VWhm1ZumR0uBjg+viYp6iRJJEuPZrVOqxWTZE=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: mingo@redhat.com
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf probe: Don't always consider EOF as an error when listing source code
References: <1292854685-8230-6-git-send-email-fbuihuu@gmail.com>
	<tip-fde52dbd7f71934aba4e150f3d1d51e826a08850@git.kernel.org>
Date: Wed, 22 Dec 2010 14:14:43 +0100
In-Reply-To: <tip-fde52dbd7f71934aba4e150f3d1d51e826a08850@git.kernel.org>
	(tip-bot for Franck Bui-Huu's message of "Wed, 22 Dec 2010 11:31:56
	GMT")
Message-ID: <m34oa6t0e4.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Franck Bui-Huu <fbuihuu@gmail.com> writes:


[...]

> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 3ba9c53..80cc0bc 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -287,7 +287,7 @@ static int get_real_path(const char *raw_path, const char *comp_dir,
>  #define LINEBUF_SIZE 256
>  #define NR_ADDITIONAL_LINES 2
>  
> -static int show_one_line(FILE *fp, int l, bool skip, bool show_num)
> +static int __show_one_line(FILE *fp, int l, bool skip, bool show_num)
>  {
>  	char buf[LINEBUF_SIZE];
>  	const char *color = show_num ? "" : PERF_COLOR_BLUE;
> @@ -306,16 +306,30 @@ static int show_one_line(FILE *fp, int l, bool skip, bool show_num)
>  
>  	} while (strchr(buf, '\n') == NULL);
>  
> -	return 0;
> +	return 1;
>  error:
> -	if (feof(fp))
> +	if (ferror(fp)) {
>  		pr_warning("Source file is shorter than expected.\n");
> -	else
> -		pr_warning("File read error: %s\n", strerror(errno));
> +		return -1;

Argh, something wrong here.

The warning left here, is the wrong one, I should have left the other
one.

Sorry for the mistake.

Should I send a patch to fix that ?
-- 
		Franck
