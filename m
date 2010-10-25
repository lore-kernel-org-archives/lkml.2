Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab0JYJax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:30:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:40077 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab0JYJaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:30:52 -0400
Message-ID: <4CC54E4D.7040401@suse.cz>
Date: Mon, 25 Oct 2010 11:30:53 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] kbuild: check return value of asprintf()
References: <1287757930-2766-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1287757930-2766-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Randy to CC)

On 22.10.2010 16:32, Namhyung Kim wrote:
> Check return value of asprintf() in docsect() and exit if error
> occurs. This removes following warning:
> 
>   HOSTCC  scripts/basic/docproc
> scripts/basic/docproc.c: In function ‘docsect’:
> scripts/basic/docproc.c:336: warning: ignoring return value of ‘asprintf’,
> 				declared with attribute warn_unused_result
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
> The patch is on top of v2.6.36, thanks.
> 
>  scripts/basic/docproc.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/basic/docproc.c b/scripts/basic/docproc.c
> index fc3b18d..98dec87 100644
> --- a/scripts/basic/docproc.c
> +++ b/scripts/basic/docproc.c
> @@ -333,7 +333,10 @@ static void docsect(char *filename, char *line)
>  		if (*s == '\n')
>  			*s = '\0';
>  
> -	asprintf(&s, "DOC: %s", line);
> +	if (asprintf(&s, "DOC: %s", line) < 0) {
> +		perror("asprintf");
> +		exit(1);
> +	}
>  	consume_symbol(s);
>  	free(s);
>  

