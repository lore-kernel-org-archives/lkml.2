Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1EPI3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:29:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:41800 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab1EPI3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:29:34 -0400
Message-ID: <4DD0E06C.2040009@suse.cz>
Date: Mon, 16 May 2011 10:29:32 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: do not record timestamp in .config
References: <1305516176-4072-1-git-send-email-lacombar@gmail.com>
In-Reply-To: <1305516176-4072-1-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.5.2011 05:22, Arnaud Lacombe wrote:
> Hi Michal,
>
> The following patch removes the timestamp in .config file. This is a
> prerequiresite for the revised version of the printer merge I sent back
> in December[0]. The issue is that heading comment generations will be
> merged in a single function, and that would revert the deterministic
> change you made in mid-April.
>
> The other options are either to have timestamp always enabled and
> disable them selectively, but that might be a pain to implement, or to
> have timestamp disable by default and an environment variable, say
> KCONFIG_TIMESTAMP, to turn everything on manually.

I personally am not a big fan of embedded timestamps, so

Acked-by: Michal Marek <mmarek@suse.cz>

But I'll wait some time before merging this, in case there are 
objections from others...

Michal


>
> Regards,
>   - Arnaud
>
> [0]: https://patchwork.kernel.org/patch/380631/
>
> --
>
> From: Arnaud Lacombe<lacombar@gmail.com>
> Subject: kconfig: do not record timestamp in .config
>
> Signed-off-by: Arnaud Lacombe<lacombar@gmail.com>
> ---
>   Documentation/kbuild/kconfig.txt |    5 -----
>   scripts/kconfig/confdata.c       |   12 +-----------
>   2 files changed, 1 insertions(+), 16 deletions(-)
>
> diff --git a/Documentation/kbuild/kconfig.txt b/Documentation/kbuild/kconfig.txt
> index cca46b1..c313d71 100644
> --- a/Documentation/kbuild/kconfig.txt
> +++ b/Documentation/kbuild/kconfig.txt
> @@ -48,11 +48,6 @@ KCONFIG_OVERWRITECONFIG
>   If you set KCONFIG_OVERWRITECONFIG in the environment, Kconfig will not
>   break symlinks when .config is a symlink to somewhere else.
>
> -KCONFIG_NOTIMESTAMP
> ---------------------------------------------------
> -If this environment variable exists and is non-null, the timestamp line
> -in generated .config files is omitted.
> -
>   ______________________________________________________________________
>   Environment variables for '{allyes/allmod/allno/rand}config'
>
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index 834eecb..2bafd9a 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -560,8 +560,6 @@ int conf_write(const char *name)
>   	const char *basename;
>   	const char *str;
>   	char dirname[PATH_MAX+1], tmpname[PATH_MAX+1], newname[PATH_MAX+1];
> -	time_t now;
> -	int use_timestamp = 1;
>   	char *env;
>
>   	dirname[0] = 0;
> @@ -598,19 +596,11 @@ int conf_write(const char *name)
>   	if (!out)
>   		return 1;
>
> -	time(&now);
> -	env = getenv("KCONFIG_NOTIMESTAMP");
> -	if (env&&  *env)
> -		use_timestamp = 0;
> -
>   	fprintf(out, _("#\n"
>   		       "# Automatically generated make config: don't edit\n"
>   		       "# %s\n"
> -		       "%s%s"
>   		       "#\n"),
> -		     rootmenu.prompt->text,
> -		     use_timestamp ? "# " : "",
> -		     use_timestamp ? ctime(&now) : "");
> +		     rootmenu.prompt->text);
>
>   	if (!conf_get_changed())
>   		sym_clear_all_valid();

